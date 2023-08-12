// Utilities
import api from "@/api";
import { Operation } from "@/api/resources/operations";
import { defineStore } from "pinia";

export const useOperationsStore = defineStore("operations", {
  state: () => ({
    operations: [] as Array<Operation>,
  }),
  actions: {
    fetchAll() {
      api.operations.getAll().then((res: Operation[]) => {
        this.operations = res;
      });
    },
  },
});
