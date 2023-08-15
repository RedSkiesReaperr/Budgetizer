<template>
  <div
    class="mb-6 d-flex flex-row justify-center flex-wrap flex-grow-1"
    :style="{ gap: '18px' }"
  >
    <InfoCard
      v-for="(f, i) in forecast()"
      v-bind:key="i"
      :loading="appStore.currentBudgetLines.length <= 0"
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
          budgetTargetAmount: f.objectiveTarget.toFixed(2),
          valueAmount: f.totalAmount.toFixed(2),
          diffValue: f.diffAmount.toFixed(2),
          diffPerentage: f.diffPercentage,
        })
      }}</template>
    </InfoCard>
  </div>

  <div class="d-flex flex-row flex-wrap">
    <BasicCard
      class="flex-grow-1"
      :loading="appStore.currentBudgetLines.length <= 0"
    >
      <v-data-table
        :items-per-page="itemsPerPage"
        :headers="headers"
        :items="appStore.currentBudgetLines"
        :sort-by="[{ key: 'attributes.amount', order: 'desc' }]"
        density="compact"
      >
        <template v-slot:[`item.attributes.lineType`]="{ item }">
          <TypeChip
            :raw-type="item.columns['attributes.lineType']"
            size="small"
          ></TypeChip>
        </template>

        <template v-slot:[`item.attributes.amount`]="{ item }">
          <span>{{ formattedAmount(item.columns["attributes.amount"]) }}</span>
        </template>

        <template v-slot:[`item.actions`]="{}">
          <v-icon size="small" class="me-2" @click="console.log('click')">
            mdi-square-edit-outline
          </v-icon>
          <v-icon size="small" class="me-2" @click="console.log('click')">
            mdi-trash-can-outline
          </v-icon>
        </template>
      </v-data-table>
    </BasicCard>
  </div>
</template>

<script lang="ts">
import { useAppStore } from "@/stores/app";
import { VDataTable } from "vuetify/lib/labs/components.mjs";
import BasicCard from "@/components/BasicCard.vue";
import InfoCard from "@/components/InfoCard.vue";
import GaugeChart from "@/components/GaugeChart.vue";
import TypeChip from "@/components/TypeChip.vue";
import { getTypeColor } from "@/services/types";
import { percentageToValue } from "@/services/calculations";

export default {
  setup() {
    const appStore = useAppStore();

    return {
      appStore,
      getTypeColor,
    };
  },
  data() {
    return {
      itemsPerPage: 30,
    };
  },
  computed: {
    headers() {
      return [
        {
          title: this.$t("line.attributes.type"),
          sortable: true,
          key: "attributes.lineType",
        },
        {
          title: this.$t("line.attributes.label"),
          sortable: true,
          key: "attributes.label",
        },
        {
          title: this.$t("line.attributes.amount"),
          sortable: true,
          key: "attributes.amount",
        },
        {
          title: this.$t("action", 2),
          sortable: false,
          key: "actions",
        },
      ];
    },
  },
  methods: {
    forecast() {
      return {
        vital: {
          translationKey: "operation.types.vital",
          objectiveTarget: percentageToValue(
            this.appStore.currentBudgetObjective.attributes.vital,
            this.appStore.currentBudget.attributes.forecastIncome
          ),
          totalAmount: this.appStore.currentBudget.attributes.forecastVital,
          diffAmount: this.appStore.currentBudget.attributes.forecastVitalDiff,
          diffPercentage: this.formattedPercentage(
            this.appStore.currentBudget.attributes.forecastVitalDiffPercentage
          ),
        },
        non_essential: {
          translationKey: "operation.types.non_essential",
          objectiveTarget: percentageToValue(
            this.appStore.currentBudgetObjective.attributes.nonEssential,
            this.appStore.currentBudget.attributes.forecastIncome
          ),
          totalAmount:
            this.appStore.currentBudget.attributes.forecastNonEssential,
          diffAmount:
            this.appStore.currentBudget.attributes.forecastNonEssentialDiff,
          diffPercentage: this.formattedPercentage(
            this.appStore.currentBudget.attributes
              .forecastNonEssentialDiffPercentage
          ),
        },
        saving: {
          translationKey: "saving",
          objectiveTarget: percentageToValue(
            this.appStore.currentBudgetObjective.attributes.saving,
            this.appStore.currentBudget.attributes.forecastIncome
          ),
          totalAmount: this.appStore.currentBudget.attributes.forecastSaving,
          diffAmount: this.appStore.currentBudget.attributes.forecastSavingDiff,
          diffPercentage: this.formattedPercentage(
            this.appStore.currentBudget.attributes.forecastSavingDiffPercentage
          ),
        },
      };
    },
    formattedAmount(rawAmount: number): string {
      return `${rawAmount.toFixed(2)} €`;
    },
    formattedPercentage(value: number): string {
      const perc = value.toFixed(2);

      return value >= 0 ? `+${perc}` : perc;
    },
  },
  components: { VDataTable, GaugeChart, BasicCard, TypeChip, InfoCard },
};
</script>
