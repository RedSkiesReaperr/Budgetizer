import {ApiResponse} from "@/api/responses";
import client from "@/api/client";
import Api from "@/api";

export interface Budget {
  id: string,
  type: 'budgets',
  links: {
    self: string
  },
  attributes: {
    name: string,
    forecastIncome: number,
    forecastVital: number,
    forecastNonEssential: number,
    forecastSaving: number,
    forecastVitalDiff: number,
    forecastNonEssentialDiff: number,
    forecastSavingDiff: number,
    forecastVitalDiffPercentage: number,
    forecastNonEssentialDiffPercentage: number,
    forecastSavingDiffPercentage: number
  },
  relationships: {
    lines: {
      links: {
        self: string,
        related: string
      }
    },
    objective: {
      links: {
        self: string,
        related: string
      }
    }
  }
}

export interface Line {
  id: string,
  type: 'lines',
  links: {
    self: string
  },
  attributes: {
    label: string,
    amount: number,
    lineType: string,
    category: string
  },
  relationships: {
    budget: {
      links: {
        self: string,
        related: string
      }
    }
  }
}

export interface Objective {
  id: string,
  type: 'objectives',
  links: {
    self: string
  },
  attributes: {
    vital: number,
    nonEssential: number,
    saving: number
  },
  relationships: {
    budget: {
      links: {
        self: string,
        related: string
      }
    }
  }
}

export const Budgets = {
  getAll: async (): Promise<ApiResponse<Array<Budget>>> => {
    const {data} = await client.get<ApiResponse<Array<Budget>>>('/budgets')
    return data
  },
  getOne: async (budgetId: number): Promise<ApiResponse<Budget>> => {
    const {data} = await client.get<ApiResponse<Array<Budget>>>(`/budgets/${budgetId}`)
    return data
  },
  getRelatedLines: async (budget: Budget): Promise<ApiResponse<Array<Line>>> => {
    const {data} = await client.get(budget.relationships.lines.links.related)
    return data
  },
  getRelatedObjective: async (budget: Budget): Promise<ApiResponse<Objective>> => {
    const {data} = await client.get(budget.relationships.objective.links.related)
    return data
  }
}
