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
import {useAppStore} from "@/stores/app";

export default {
  setup() {
    const operationsStore = useOperationsStore();
    const appStore = useAppStore()

    return { operationsStore, appStore };
  },
  data() {
    return {
      operations: [] as Array<Operation>,
    };
  },
  mounted() {
    if (this.operationsStore.expenses.length <= 0) {
      this.operationsStore.fetchAll(this.appStore.currentDateStartAt, this.appStore.currentDateEndAt)
    }
  },
  components: { BasicCard, OperationsTable },
};
</script>
