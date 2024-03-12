<template>
  <div
    v-if="forecastsStore.forecasts.attributes && objectivesStore.objective.attributes"
    class="mb-6 d-flex flex-row justify-center flex-wrap flex-grow-1"
    :style="{ gap: '18px' }"
  >
    <InfoCard
      v-for="(f, i) in forecast()"
      v-bind:key="i"
      :loading="linesStore.lines.length <= 0"
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
      :loading="linesStore.fetching || linesStore.lines.length <= 0"
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

                <v-form ref="createForm">
                  <v-row>
                    <v-col cols="12" sm="6" md="6">
                      <v-text-field
                        v-model="createdLine.attributes.label"
                        :label="$t('operation.attributes.label')"
                        variant="outlined"
                        :rules="createRules.label"
                        clearable
                        required
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" md="3">
                      <v-text-field
                        v-model="createdLine.attributes.amount"
                        :label="$t('operation.attributes.amount')"
                        variant="outlined"
                        type="number"
                        :rules="createRules.amount"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="3">
                      <v-select
                        v-model="createdLine.attributes.lineType"
                        small-chips
                        default="createdLine.attributes.lineType"
                        :label="$t('operation.attributes.type')"
                        :items="availableTypes"
                        :rules="createRules.type"
                        item-value="value"
                        variant="outlined"
                      >
                        <template v-slot:item="{ props, item }">
                          <v-list-item v-bind="props" :title="$t(getTypeTranslationKey(item.value))"></v-list-item>
                        </template>
                        <template #selection="{ item }">
                          <TypeChip
                            :raw-type="item.value"
                            size="small"
                          ></TypeChip>
                        </template>
                      </v-select>
                    </v-col>
                  </v-row>
                </v-form>
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
              <v-btn color="blue-darken-1" variant="text" @click="createLine">
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
import TypeChip from "@/components/TypeChip.vue";
import {getTypeColor, getTypeTranslationKey} from "@/services/types";
import {percentageToValue} from "@/services/calculations";
import {Line} from "@/api/resources/lines";
import api from "@/api";
import {copyLine} from "@/services/lines";
import {VForm} from "vuetify/lib/components/index.mjs";
import {formatNumber, formatPercentage} from '@/services/formatters'
import {useForecastsStore} from "@/stores/forecasts";
import {useObjectivesStore} from "@/stores/objectives";
import {useLinesStore} from "@/stores/lines";

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
      availableTypes: ["income", "vital", "non_essential"],
      // Create Line
      defaultLine: {} as Line,
      createDialog: false,
      createError: false,
      createLoading: false,
      createdLine: {} as Line,
      createRules: {
        label: [
          (value: string) =>
            value ? true : this.$t("form_validations.required"),
        ],
        amount: [
          (value: number) =>
            value && value > 0
              ? true
              : this.$t("form_validations.gt", {limit: 0}),
        ],
        type: [
          (value: string) =>
            value ? true : this.$t("form_validations.required"),
        ],
      },
    };
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
    async createLine() {
      const {valid} = await (this.$refs.createForm as VForm).validate();

      if (valid) {
        const createPayload = {
          label: this.createdLine.attributes.label,
          amount: this.createdLine.attributes.amount,
          lineType: this.createdLine.attributes.lineType,
          category: this.createdLine.attributes.category,
        };

        this.createLoading = true;
        await api.lines
          .createOne(createPayload)
          .then(() => {
            this.refreshInfos().then(() => this.closeCreateDialog())
          })
          .catch(() => this.createError = true)
          .finally(() => this.createLoading = false);
      }
    },
    closeCreateDialog() {
      this.createDialog = false;
    },
    async refreshInfos(): Promise<any> {
      return Promise.all([this.linesStore.fetchAll(), this.forecastsStore.fetch(), this.objectivesStore.fetchAll()])
    }
  },
  components: {GaugeChart, BasicCard, LinesTable, TypeChip, InfoCard},
};
</script>
