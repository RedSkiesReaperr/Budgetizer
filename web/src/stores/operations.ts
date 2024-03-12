import api from "@/api";
import {Operation} from "@/api/resources/operations";
import {defineStore} from "pinia";
import moment from "moment";

export const useOperationsStore = defineStore("operations", {
  state: () => ({
    operations: [] as Operation[],
    fetching: false,
  }),
  getters: {
    incomes: (state): Operation[] => state.operations.filter((o) => o.attributes.amount >= 0),
    expenses: (state): Operation[] => state.operations.filter((o) => o.attributes.amount < 0)
  },
  actions: {
    async fetchAll(startAt: moment.Moment, endAt: moment.Moment) {
      this.fetching = true;

      api.operations.getAll(startAt, endAt)
        .then((res: Operation[]) => this.operations = res)
        .finally(() => this.fetching = false);
    },
  }
});
