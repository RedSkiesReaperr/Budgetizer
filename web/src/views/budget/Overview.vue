<template>
  <div class="d-flex flex-row flex-wrap">
    <BasicCard
      class="pb-4 flex-grow-0"
      :loading="operationsStore.fetching"
      :style="{ overflow: 'visible' }"
    >
      <CategoriesPieChart />
    </BasicCard>
  </div>
</template>

<script lang="ts">
import BasicCard from "@/components/BasicCard.vue";
import CategoriesPieChart from "@/components/CategoriesPieChart.vue";
import {useOperationsStore} from "@/stores/operations";
import {useAppStore} from "@/stores/app";

export default {
  setup() {
    const operationsStore = useOperationsStore();
    const appStore = useAppStore()

    return { operationsStore, appStore };
  },
  mounted() {
    if (this.operationsStore.expenses.length <= 0) {
      this.operationsStore.fetchAll(this.appStore.currentDateStartAt, this.appStore.currentDateEndAt)
    }
  },
  components: { BasicCard, CategoriesPieChart }
}
</script>
