<template>
  <v-container>
    <div class="mb-6" :style="{ textAlign: 'center' }">
      <h1>{{ $t("budget_selector.title") }}</h1>
    </div>

    <div
      class="d-flex flex-grow-0"
      v-for="item in budgetsStore.budgets"
      :key="item.id"
    >
      <BasicCard :loading="false">
        <div class="text-h6">{{ item.attributes.name }}</div>
        <div class="text-body-2">
          {{ $t("operation.attributes.id") }}: {{ item.id }}
        </div>
        <v-btn
          class="mt-8"
          @click="selectBudget(item)"
          color="primary"
          append-icon="mdi-arrow-right-bold"
          >{{ $t("budget_selector.select_btn") }}</v-btn
        ></BasicCard
      >
    </div>
  </v-container>
</template>

<script lang="ts">
import { Budget } from "@/api/resources/budgets";
import BasicCard from "@/components/BasicCard.vue";
import { useBudgetsStore } from "@/stores/budgets";
import { useAppStore } from "@/stores/app";
import routes from "@/router/routes";

export default {
  setup() {
    const budgetsStore = useBudgetsStore();
    const appStore = useAppStore();

    return { appStore, budgetsStore };
  },
  created() {
    this.budgetsStore.fetchAll();
  },
  data() {
    return {
      itemsPerPage: 10,
    };
  },
  methods: {
    selectBudget(budget: Budget) {
      this.appStore.selectBudget(budget);
      this.$router.push(routes.budget.overview);
    },
  },
  components: { BasicCard },
};
</script>
