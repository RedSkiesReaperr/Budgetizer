// Utilities
import api from "@/api";
import { Operation } from "@/api/resources/operations";
import { defineStore } from "pinia";

export const useOperationsStore = defineStore("operations", {
  state: () => ({
    incomes: [] as Operation[],
    expenses: [] as Operation[],
  }),
  actions: {
    async fetchAll() {
      api.operations.getAll().then((res: Operation[]) => {
        this.incomes = [];
        this.expenses = [];

        res.forEach((operation: Operation) => {
          if (operation.attributes.amount >= 0) {
            this.incomes.push(operation);
          } else {
            this.expenses.push(operation);
          }
        });
      });
    },
  },
});
