// Utilities
import api from "@/api";
import { Budget } from "@/api/resources/budgets";
import { defineStore } from "pinia";

export const useBudgetsStore = defineStore("budgets", {
  state: () => ({
    budgets: [] as Budget[],
  }),
  actions: {
    async fetchAll() {
      api.budgets.getAll().then((res: Budget[]) => {
        this.budgets = res;
      });
    },
  },
});
