// stores/counter.spec.ts
import {setActivePinia, createPinia} from "pinia";
import {expect, describe, beforeEach, it, vi} from "vitest";
import {useOperationsStore} from "@/stores/operations";
import OperationsRequests, {Operation} from "@/api/resources/operations";
import api from "@/api";
import moment from "moment";

describe("operations Store", () => {
  const incomeOperation = {
    id: "1",
    type: "operations",
    links: {
      self: "self_url",
    },
    attributes: {
      date: "a date",
      label: "a label",
      amount: 21.06,
      comment: "",
      pointed: true,
      opType: "a type",
      categoryId: 1,
    },
  };

  const expenseOperation = {
    id: "2",
    type: "operations",
    links: {
      self: "self_url",
    },
    attributes: {
      date: "a date",
      label: "a label",
      amount: -21.06,
      comment: "",
      pointed: true,
      opType: "a type",
      categoryId: 2,
    },
  };

  const allOperations: Operation[] = [incomeOperation, expenseOperation];

  beforeEach(() => {
    setActivePinia(createPinia());
  });

  describe("getter incomes", () => {
    it("returns only incomes operations", async () => {
      vi.spyOn(OperationsRequests, "getAll").mockImplementationOnce(() =>
        Promise.resolve<Operation[]>(allOperations)
      );

      const store = useOperationsStore();
      expect(store.incomes).toStrictEqual([]);
      await store.fetchAll(moment(), moment());
      expect(store.incomes).toStrictEqual([incomeOperation]);
    });
  })

  describe("getter expenses", () => {
    it("returns only expenses operations", async () => {
      vi.spyOn(OperationsRequests, "getAll").mockImplementationOnce(() =>
        Promise.resolve<Operation[]>(allOperations)
      );

      const store = useOperationsStore();
      expect(store.expenses).toStrictEqual([]);
      await store.fetchAll(moment(), moment());
      expect(store.expenses).toStrictEqual([expenseOperation]);
    });
  })
  describe("fetchAll", () => {
    it("fills operations", async () => {
      vi.spyOn(api.operations, "getAll").mockImplementationOnce(() =>
        Promise.resolve<Operation[]>(allOperations)
      );
      const store = useOperationsStore();
      expect(store.operations).toStrictEqual([]);
      await store.fetchAll(moment(), moment());
      expect(store.operations).toStrictEqual([incomeOperation, expenseOperation]);
    });
  });
});
