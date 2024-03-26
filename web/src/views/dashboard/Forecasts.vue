<template>
  <v-row v-if="forecastsStore.forecasts.attributes && objectivesStore.objective.attributes" justify="center">
    <v-col
      cols="12" xs="12" sm="6" md="4" lg="3" xl="2" xxl="2"
      v-for="(f, i) in forecast()"
      v-bind:key="i"
    >
      <InfoCard :loading="linesStore.fetching">
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
    </v-col>
  </v-row>

  <v-row justify="center">
    <v-col cols="12" xs="12" sm="12" md="12" lg="9" xl="6" xxl="6">
      <BasicCard :loading="linesStore.fetching">
        <v-btn
          icon="mdi-plus-circle-outline"
          variant="text"
          color="green"
          :style="{ position: 'absolute', top: 0, right: 0 }"
          @click="openCreateLine"
        >
        </v-btn>

        <LinesTable :lines="linesStore.lines" @line-change="refreshInfos"/>

      </BasicCard>
    </v-col>
  </v-row>

  <ConfirmationModal :is-open="createDialog" :loading="createLoading" @cancel="closeCreateDialog" @confirm="submitCreate">
    <template v-slot:title>{{ $t("line.creation.title") }}</template>
    <template v-slot:content>
      <v-container>
        <LineForm
          ref="lineFormEdit"
          :mode="LineFormMode.CREATE"
          :target="createdLine"
          @submit="createSubmitting"
          @success="createSucceed"
          @fail="(err: any) => createFailed()"
          @finish="createSubmitted"
        />
      </v-container>
    </template>
  </ConfirmationModal>
  <Alert/>
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
import Alert from "@/components/Alert.vue";
import {AlertType, useAlertStore} from "@/stores/alert";
import ConfirmationModal from "@/components/ConfirmationModal.vue";

export default {
  setup() {
    const appStore = useAppStore();
    const forecastsStore = useForecastsStore();
    const objectivesStore = useObjectivesStore();
    const linesStore = useLinesStore();
    const alertStore = useAlertStore();

    return {
      appStore,
      forecastsStore,
      objectivesStore,
      linesStore,
      alertStore,
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
      (this.$refs.lineFormEdit as any).$refs.form.$refs.form.requestSubmit()
    },
    createSubmitting() {
      this.createLoading = true
    },
    createSucceed() {
      this.alertStore.show(AlertType.Success, this.$t('line.creation.success_title'), this.$t('line.creation.success_message'))
      this.refreshInfos().then(() => this.closeCreateDialog())
    },
    createFailed() {
      this.alertStore.show(AlertType.Error, this.$t('line.creation.error'), '')
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
  components: {ConfirmationModal, Alert, GaugeChart, BasicCard, LinesTable, LineForm, InfoCard},
};
</script>
