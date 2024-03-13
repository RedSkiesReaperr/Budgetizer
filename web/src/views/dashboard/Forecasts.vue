<template>
  <div
    v-if="forecastsStore.forecasts.attributes && objectivesStore.objective.attributes"
    class="mb-6 d-flex flex-row justify-center flex-wrap flex-grow-1"
    :style="{ gap: '18px' }"
  >
    <InfoCard
      v-for="(f, i) in forecast()"
      v-bind:key="i"
      :loading="linesStore.fetching"
    >
      <template v-slot:main>
        <GaugeChart
          :label="$t(f.translationKey)"
          :color="getTypeColor(i)"
          :value="f.totalAmount"
          :max-value="f.objectiveTarget"
        ></GaugeChart>
      </template>
      <template v-slot:info>{{
          $t("forecast_page.card_info", {
            type: $t(f.translationKey),
            budgetTargetAmount: formatNumber(f.objectiveTarget),
            valueAmount: formatNumber(f.totalAmount),
            diffValue: formatNumber(f.diffAmount),
            diffPercentage: formatPercentage(f.diffPercentage),
          })
        }}
      </template>
    </InfoCard>
  </div>

  <div class="d-flex flex-row flex-wrap">
    <BasicCard
      class="pb-10 flex-grow-1"
      :loading="linesStore.fetching"
    >
      <v-btn
        icon="mdi-plus-circle-outline"
        variant="text"
        color="green"
        :style="{ position: 'absolute', top: 0, right: 0 }"
        @click="openCreateLine"
      >
      </v-btn>

      <LinesTable :lines="linesStore.lines" :onLinesChanged="refreshInfos"/>

      <v-row justify="center">
        <v-dialog v-model="createDialog" persistent>
          <v-card>
            <v-card-title class="pt-4">
              <span class="text-h5">{{ $t("line.creation.title") }}</span>
            </v-card-title>
            <v-card-text>
              <v-container>
                <v-overlay
                  class="align-center justify-center"
                  :model-value="createLoading"
                  :close-on-content-click="false"
                  contained
                  disabled
                  persistent
                >
                  <v-progress-circular
                    color="primary"
                    indeterminate
                  ></v-progress-circular>
                </v-overlay>

                <LineForm
                  ref="lineFormEdit"
                  :mode="LineFormMode.CREATE"
                  :target="createdLine"
                  :on-submitting="createSubmitting"
                  :on-submit-success="createSucceed"
                  :on-submit-failed="createFailed"
                  :on-submitted="createSubmitted"
                />
              </v-container>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-alert
                closable
                v-model="createError"
                :text="$t('operation.edition.error')"
                type="error"
                variant="tonal"
              ></v-alert>
              <v-spacer></v-spacer>
              <v-btn
                color="blue-darken-1"
                variant="text"
                @click="closeCreateDialog"
              >
                {{ $t("actions.cancel") }}
              </v-btn>
              <v-btn color="blue-darken-1" variant="text" @click="submitCreate">
                {{ $t("actions.create") }}
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-row>
    </BasicCard>
  </div>
</template>

<script lang="ts">
import {useAppStore} from "@/stores/app";
import BasicCard from "@/components/BasicCard.vue";
import InfoCard from "@/components/InfoCard.vue";
import GaugeChart from "@/components/GaugeChart.vue";
import LinesTable from "@/components/LinesTable.vue";
import {getTypeColor, getTypeTranslationKey} from "@/services/types";
import {percentageToValue} from "@/services/calculations";
import {copyLine} from "@/services/lines";
import {formatNumber, formatPercentage} from '@/services/formatters'
import {useForecastsStore} from "@/stores/forecasts";
import {useObjectivesStore} from "@/stores/objectives";
import {useLinesStore} from "@/stores/lines";
import LineForm, {LineFormMode} from "@/components/LineForm.vue";
import {Line} from "@/api/resources/lines";

export default {
  setup() {
    const appStore = useAppStore();
    const forecastsStore = useForecastsStore();
    const objectivesStore = useObjectivesStore();
    const linesStore = useLinesStore();

    return {
      appStore,
      forecastsStore,
      objectivesStore,
      linesStore,
      getTypeColor,
      formatNumber,
    };
  },
  mounted() {
    if (this.linesStore.lines.length <= 0) {
      this.linesStore.fetchAll()
    }

    if (!this.objectivesStore.objective.attributes) {
      this.objectivesStore.fetchAll()
    }

    if (!this.forecastsStore.forecasts.attributes) {
      this.forecastsStore.fetch()
    }
  },
  data() {
    return {
      defaultLine: {} as Line,
      createDialog: false,
      createError: false,
      createLoading: false,
      createdLine: {} as Line,
    };
  },
  computed: {
    LineFormMode: () => LineFormMode
  },
  methods: {
    getTypeTranslationKey,
    formatPercentage,
    forecast() {
      return {
        vital: {
          translationKey: "operation.types.vital",
          objectiveTarget: percentageToValue(this.objectivesStore.vital, this.forecastsStore.income),
          totalAmount: this.forecastsStore.vital,
          diffAmount: this.forecastsStore.vitalDiff,
          diffPercentage: this.forecastsStore.vitalDiffPercentage,
        },
        non_essential: {
          translationKey: "operation.types.non_essential",
          objectiveTarget: percentageToValue(this.objectivesStore.nonEssential, this.forecastsStore.income),
          totalAmount: this.forecastsStore.nonEssential,
          diffAmount: this.forecastsStore.nonEssentialDiff,
          diffPercentage: this.forecastsStore.nonEssentialDiffPercentage,
        },
        saving: {
          translationKey: "saving",
          objectiveTarget: percentageToValue(this.objectivesStore.saving, this.forecastsStore.income),
          totalAmount: this.forecastsStore.saving,
          diffAmount: this.forecastsStore.savingDiff,
          diffPercentage: this.forecastsStore.savingDiffPercentage,
        },
      };
    },
    openCreateLine() {
      this.createdLine = copyLine(this.defaultLine);
      this.createDialog = true;
    },
    submitCreate() {
      (this.$refs.lineFormEdit as any).$refs.form.requestSubmit()
    },
    createSubmitting() {
      this.createLoading = true
    },
    createSucceed() {
      this.refreshInfos().then(() => this.closeCreateDialog())
    },
    createFailed() {
      this.createError = true
    },
    createSubmitted() {
      this.createLoading = false
    },
    closeCreateDialog() {
      this.createDialog = false;
      this.createError = false;
    },
    async refreshInfos(): Promise<any> {
      return Promise.all([this.linesStore.fetchAll(), this.forecastsStore.fetch(), this.objectivesStore.fetchAll()])
    }
  },
  components: {GaugeChart, BasicCard, LinesTable, LineForm, InfoCard},
};
</script>
