<template>
  <BasicCard :loading="operationsStore.incomes.length <= 0">
    <OperationsTable :data="operationsStore.incomes" />
  </BasicCard>
</template>

<script lang="ts">
import { Operation } from "@/api/resources/operations";
import { useOperationsStore } from "@/stores/operations";
import BasicCard from "@/components/BasicCard.vue";
import OperationsTable from "@/components/OperationsTable.vue";

export default {
  setup() {
    const operationsStore = useOperationsStore();

    return { operationsStore };
  },
  data() {
    return {
      incomesLoading: true,
      operations: [] as Array<Operation>,
    };
  },
  created() {
    if (this.operationsStore.incomes.length <= 0) {
      this.operationsStore.fetchAll();
    }
  },
  components: { BasicCard, OperationsTable },
};
</script>
