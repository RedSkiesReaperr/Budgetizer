// stores/counter.spec.ts
import { setActivePinia, createPinia } from "pinia";
import { expect, describe, beforeEach, it } from "vitest";
import { useAppStore } from "./app";
import { Budget } from "@/api/resources/budgets";

describe("app Store", () => {
  const budget: Budget = {
    id: "1",
    type: "budgets",
    links: {
      self: "some_url",
    },
    attributes: {
      name: "Budget name",
      forecastIncome: 1.2,
      forecastVital: 1.2,
      forecastNonEssential: 1.2,
      forecastSaving: 1.2,
      forecastVitalDiff: 1.2,
      forecastNonEssentialDiff: 1.2,
      forecastSavingDiff: 1.2,
      forecastVitalDiffPercentage: 1.2,
      forecastNonEssentialDiffPercentage: 1.2,
      forecastSavingDiffPercentage: 1.2,
    },
    relationships: {
      lines: {
        links: {
          self: "some_url",
          related: "some_url",
        },
      },
      objective: {
        links: {
          self: "some_url",
          related: "some_url",
        },
      },
    },
  };
  beforeEach(() => {
    setActivePinia(createPinia());
  });

  it("selectBudget", () => {
    const store = useAppStore();
    expect(store.currentBudget).toStrictEqual({});
    store.selectBudget(budget);
    expect(store.currentBudget).toStrictEqual(budget);
  });
});
