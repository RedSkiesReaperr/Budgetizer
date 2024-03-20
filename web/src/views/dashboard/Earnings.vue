<template>
  <v-row justify="center">
    <v-col cols="12" xs="12" sm="12" md="12" lg="12" xl="10" xxl="8">
      <BasicCard class="pb-10" :loading="operationsStore.fetching">
        <OperationsTable :operations="operationsStore.incomes"
                         :categories="categoriesStore.categories"
                         :on-operations-changed="refreshOperations"/>
      </BasicCard>
    </v-col>
  </v-row>
</template>

<script lang="ts">
import {Operation} from "@/api/resources/operations";
import {useOperationsStore} from "@/stores/operations";
import BasicCard from "@/components/BasicCard.vue";
import OperationsTable from "@/components/OperationsTable.vue";
import {useAppStore} from "@/stores/app";
import {useCategoriesStore} from "@/stores/categories";

export default {
  setup() {
    const operationsStore = useOperationsStore();
    const appStore = useAppStore()
    const categoriesStore = useCategoriesStore();

    return {operationsStore, appStore, categoriesStore};
  },
  data() {
    return {
      operations: [] as Array<Operation>,
    };
  },
  mounted() {
    if (this.operationsStore.incomes.length <= 0) {
      this.operationsStore.fetchAll(this.appStore.currentDateStartAt, this.appStore.currentDateEndAt)
    }

    if (this.categoriesStore.categories.length <= 0) {
      this.categoriesStore.fetchAll()
    }
  },
  methods: {
    async refreshOperations(): Promise<any> {
      return this.operationsStore.fetchAll(this.appStore.currentDateStartAt, this.appStore.currentDateEndAt)
    }
  },
  components: {BasicCard, OperationsTable},
};
</script>
