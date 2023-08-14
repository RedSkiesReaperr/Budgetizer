// Utilities
import { defineStore } from "pinia";
import { Budget, Line, Objective } from "@/api/resources/budgets";
import api from "@/api";

export const useAppStore = defineStore("app", {
  state: () => ({
    currentBudget: {} as Budget,
    currentBudgetLines: [] as Line[],
    currentBudgetObjective: {} as Objective,
  }),
  actions: {
    async selectBudget(budget: Budget) {
      this.currentBudget = budget;

      api.budgets.getRelatedLines(budget).then((res: Line[]) => {
        this.currentBudgetLines = res;
      });

      api.budgets.getRelatedObjective(budget).then((res: Objective) => {
        this.currentBudgetObjective = res;
      });
    },
  },
});
