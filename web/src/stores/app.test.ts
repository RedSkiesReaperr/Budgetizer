// stores/counter.spec.ts
import { setActivePinia, createPinia } from "pinia";
import { expect, describe, beforeEach, it, vi } from "vitest";
import { useAppStore } from "./app";
import BudgetsRequests, {
  Budget,
  Line,
  Objective,
} from "@/api/resources/budgets";

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

  const lines: Line[] = [
    {
      id: "1",
      type: "lines",
      links: {
        self: "some_url",
      },
      attributes: {
        label: "aaa",
        amount: 5467.86,
        lineType: "uiu",
        category: "yys",
      },
      relationships: {
        budget: {
          links: {
            self: "some_url",
            related: "some_url",
          },
        },
      },
    },
  ];

  const objective: Objective = {
    id: "1",
    type: "objectives",
    links: {
      self: "some_url",
    },
    attributes: {
      vital: 1,
      nonEssential: 2,
      saving: 3,
    },
    relationships: {
      budget: {
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

  it("selectBudget", async () => {
    vi.spyOn(BudgetsRequests, "getRelatedLines").mockImplementationOnce(() =>
      Promise.resolve<Line[]>(lines)
    );

    vi.spyOn(BudgetsRequests, "getRelatedObjective").mockImplementationOnce(
      () => Promise.resolve<Objective>(objective)
    );

    const store = useAppStore();
    expect(store.currentBudget).toStrictEqual({});
    expect(store.currentBudgetLines).toStrictEqual([]);
    expect(store.currentBudgetObjective).toStrictEqual({});
    await store.selectBudget(budget);
    expect(store.currentBudget).toStrictEqual(budget);
    expect(store.currentBudgetLines).toStrictEqual(lines);
    expect(store.currentBudgetObjective).toStrictEqual(objective);
  });
});
