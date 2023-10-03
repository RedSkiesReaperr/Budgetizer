// Utilities
import api from "@/api";
import {Operation} from "@/api/resources/operations";
import {defineStore} from "pinia";
import moment from "moment";

export const useOperationsStore = defineStore("operations", {
  state: () => ({
    incomes: [] as Operation[],
    expenses: [] as Operation[],
    fetching: false,
  }),
  actions: {
    async fetchAll(startAt: moment.Moment, endAt: moment.Moment) {
      this.fetching = true;

      api.operations
        .getAll(startAt, endAt)
        .then((res: Operation[]) => {
          this.incomes = [];
          this.expenses = [];

          res.forEach((operation: Operation) => {
            if (operation.attributes.amount >= 0) {
              this.incomes.push(operation);
            } else {
              this.expenses.push(operation);
            }
          });
        })
        .finally(() => {
          this.fetching = false;
        });
    },
  },
  getters: {
    all: (state): Operation[] => [...state.incomes, ...state.expenses],
    totalExpenses: (state): number => state.expenses.reduce((sum, op) => sum + op.attributes.amount, 0)
  }
});
