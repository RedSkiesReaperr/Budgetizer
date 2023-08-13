// Utilities
import { defineStore } from "pinia";
import { Budget } from "@/api/resources/budgets";

export const useAppStore = defineStore("app", {
  state: () => ({
    currentBudget: {} as Budget,
  }),
  actions: {
    selectBudget(budget: Budget) {
      this.currentBudget = budget;
    },
  },
});
