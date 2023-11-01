<template>
  <div class="mb-8 d-flex flex-row flex-wrap" :style="{ gap: '18px' }">
    <BasicCard
      class="h-25 w-25 px-0 py-0 flex-grow-0"
      :loading="operationsStore.fetching"
    >
      <OperationsSparkLineChart
        :subtitle="$t('earning', 2)"
        :operations="operationsStore.incomes"
        :x-axis-labels="daysChartLabels"
        curve-color="#00b894"
      />
    </BasicCard>
    <BasicCard
      class="h-25 w-25 px-0 py-0 flex-grow-0"
      :loading="operationsStore.fetching"
    >
      <OperationsSparkLineChart
        :subtitle="$t('expense', 2)"
        :operations="operationsStore.expenses"
        :x-axis-labels="daysChartLabels"
        curve-color="#d63031"
      />
    </BasicCard>
    <BasicCard
      class="pb-4 w-25 flex-grow-0"
      :loading="operationsStore.fetching"
      :style="{ overflow: 'visible' }"
    >
      <CategoriesPieChart/>
    </BasicCard>
  </div>
</template>

<script lang="ts">
import BasicCard from "@/components/BasicCard.vue";
import {useOperationsStore} from "@/stores/operations";
import {useAppStore} from "@/stores/app";
import CategoriesPieChart from "@/components/CategoriesPieChart.vue";
import OperationsSparkLineChart from "@/components/OperationsSparkLineChart.vue";
import {daysInRangeAsStr} from "@/services/dates";

export default {
  setup() {
    const operationsStore = useOperationsStore();
    const appStore = useAppStore()

    return {operationsStore, appStore};
  },
  mounted() {
    if (this.operationsStore.expenses.length <= 0) {
      this.operationsStore.fetchAll(this.appStore.currentDateStartAt, this.appStore.currentDateEndAt)
    }
  },
  computed: {
    daysChartLabels(): string[] {
      return daysInRangeAsStr(this.appStore.currentDateStartAt, this.appStore.currentDateEndAt, "YYYY-MM-DD")
    },
  },
  components: {BasicCard, CategoriesPieChart, OperationsSparkLineChart}
}
</script>
