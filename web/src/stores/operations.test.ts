// stores/counter.spec.ts
import { setActivePinia, createPinia } from "pinia";
import { expect, describe, beforeEach, it, vi } from "vitest";
import { useOperationsStore } from "@/stores/operations";
import OperationsRequests, { Operation } from "@/api/resources/operations";
import api from "@/api";

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
      category: "a category",
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
      category: "a category",
    },
  };

  beforeEach(() => {
    setActivePinia(createPinia());
  });

  describe("fetchAll", () => {
    it("fills incomes", async () => {
      vi.spyOn(OperationsRequests, "getAll").mockImplementationOnce(() =>
        Promise.resolve<Operation[]>([incomeOperation])
      );

      const store = useOperationsStore();
      expect(store.incomes).toStrictEqual([]);
      expect(store.expenses).toStrictEqual([]);
      await store.fetchAll(1, 2);
      expect(store.incomes).toStrictEqual([incomeOperation]);
      expect(store.expenses).toStrictEqual([]);
    });

    it("fills expenses", async () => {
      vi.spyOn(api.operations, "getAll").mockImplementationOnce(() =>
        Promise.resolve<Operation[]>([expenseOperation])
      );
      const store = useOperationsStore();
      expect(store.incomes).toStrictEqual([]);
      expect(store.expenses).toStrictEqual([]);
      await store.fetchAll(1, 2);
      console.log("FINISH")
      expect(store.incomes).toStrictEqual([]);
      expect(store.expenses).toStrictEqual([expenseOperation]);
    });
  });
});
