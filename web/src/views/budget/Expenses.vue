<template>
  <BasicCard class="pb-10" :loading="operationsStore.fetching">
    <OperationsTable :data="operationsStore.expenses" />
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
      operations: [] as Array<Operation>,
    };
  },
  components: { BasicCard, OperationsTable },
};
</script>
