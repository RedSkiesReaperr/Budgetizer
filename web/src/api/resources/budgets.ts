import { ApiResponse } from "@/api/responses";
import client from "@/api/client";

export interface Budget {
  id: string;
  type: "budgets";
  links: {
    self: string;
  };
  attributes: {
    name: string;
    forecastIncome: number;
    forecastVital: number;
    forecastNonEssential: number;
    forecastSaving: number;
    forecastVitalDiff: number;
    forecastNonEssentialDiff: number;
    forecastSavingDiff: number;
    forecastVitalDiffPercentage: number;
    forecastNonEssentialDiffPercentage: number;
    forecastSavingDiffPercentage: number;
  };
  relationships: {
    lines: {
      links: {
        self: string;
        related: string;
      };
    };
    objective: {
      links: {
        self: string;
        related: string;
      };
    };
  };
}

export interface Line {
  id: string;
  type: "lines";
  links: {
    self: string;
  };
  attributes: {
    label: string;
    amount: number;
    lineType: string;
    category: string;
  };
  relationships: {
    budget: {
      links: {
        self: string;
        related: string;
      };
    };
  };
}

export interface Objective {
  id: string;
  type: "objectives";
  links: {
    self: string;
  };
  attributes: {
    vital: number;
    nonEssential: number;
    saving: number;
  };
  relationships: {
    budget: {
      links: {
        self: string;
        related: string;
      };
    };
  };
}

export default {
  getAll: getAll,
  getOne: getOne,
  getRelatedLines: getRelatedLines,
  getRelatedObjective: getRelatedObjective,
};

async function getAll(): Promise<Budget[]> {
  return (await client.get<ApiResponse<Budget[]>>("/budgets")).data.data;
}

async function getOne(budgetId: number): Promise<Budget> {
  return (await client.get<ApiResponse<Budget>>(`/budgets/${budgetId}`)).data
    .data;
}

async function getRelatedLines(budget: Budget): Promise<Line[]> {
  return (
    await client.get<ApiResponse<Line[]>>(
      budget.relationships.lines.links.related
    )
  ).data.data;
}

async function getRelatedObjective(budget: Budget): Promise<Objective> {
  return (
    await client.get<ApiResponse<Objective>>(
      budget.relationships.objective.links.related
    )
  ).data.data;
}
