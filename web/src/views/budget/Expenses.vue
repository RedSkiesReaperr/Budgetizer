<template>
  <BasicCard :loading="operationsStore.operations.length <= 0">
    <OperationsTable :data="operationsStore.operations" />
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
      expensesLoading: true,
      operations: [] as Array<Operation>,
    };
  },
  created() {
    this.operationsStore.fetchAll();
  },
  components: { BasicCard, OperationsTable },
};
</script>
