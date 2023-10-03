// Utilities
import { defineStore } from "pinia";
import { Budget, Objective } from "@/api/resources/budgets";
import api from "@/api";
import { Line } from "@/api/resources/lines";
import {
  percentageToValue,
  variationPercentage,
} from "@/services/calculations";
import moment from "moment";
import { useOperationsStore } from "./operations";
import { useStorage } from '@vueuse/core'

export const useAppStore = defineStore("app", {
  state: () => ({
    currentDateStartAt: useStorage('currentDateStartAt', moment().startOf("month"), undefined, {
      serializer: {
        read: (v: string): moment.Moment => moment(v),
        write: (v: moment.Moment): string => v.toString()
      }
    }),
    currentDateEndAt: useStorage('currentDateEndAt', moment().endOf("month"), undefined, {
      serializer: {
        read: (v: string): moment.Moment => moment(v),
        write: (v: moment.Moment): string => v.toString()
      }
    }),
    currentBudget: {} as Budget,
    currentBudgetLines: [] as Line[],
    currentBudgetObjective: {} as Objective,
  }),
  getters: {
    currentDays(state) {
      const days: moment.Moment[] = []

      for(let i = state.currentDateStartAt.clone(); i.isBefore(this.currentDateEndAt.clone()); i.add(1, "days")) {
        days.push(i.clone())
      }

      return days
    },
    // Income
    forecastIncome: (state): number =>
      state.currentBudgetLines
        .filter((l) => l.attributes.lineType === "income")
        .reduce((sum, op) => sum + op.attributes.amount, 0),
    forecastVital: (state): number =>
      state.currentBudgetLines
        .filter((l) => l.attributes.lineType === "vital")
        .reduce((sum, op) => sum + op.attributes.amount, 0),
    forecastVitalDiffValue(state): number {
      return (
        this.forecastVital -
        percentageToValue(
          state.currentBudgetObjective.attributes.vital,
          this.forecastIncome
        )
      );
    },
    forecastVitalDiffPercentage(state): number {
      return variationPercentage(
        percentageToValue(
          state.currentBudgetObjective.attributes.vital,
          this.forecastIncome
        ),
        this.forecastVital
      );
    },
    // Non essential
    forecastNonEssential: (state): number =>
      state.currentBudgetLines
        .filter((l) => l.attributes.lineType === "non_essential")
        .reduce((sum, op) => sum + op.attributes.amount, 0),
    forecastNonEssentialDiffValue(state): number {
      return (
        this.forecastNonEssential -
        percentageToValue(
          state.currentBudgetObjective.attributes.nonEssential,
          this.forecastIncome
        )
      );
    },
    forecastNonEssentialDiffPercentage(state): number {
      return variationPercentage(
        percentageToValue(
          state.currentBudgetObjective.attributes.nonEssential,
          this.forecastIncome
        ),
        this.forecastNonEssential
      );
    },
    // Saving
    forecastSaving(): number {
      return (
        this.forecastIncome - (this.forecastVital + this.forecastNonEssential)
      );
    },
    forecastSavingDiffValue(state): number {
      return (
        this.forecastSaving -
        percentageToValue(
          state.currentBudgetObjective.attributes.saving,
          this.forecastIncome
        )
      );
    },
    forecastSavingDiffPercentage(state): number {
      return variationPercentage(
        percentageToValue(
          state.currentBudgetObjective.attributes.saving,
          this.forecastIncome
        ),
        this.forecastSaving
      );
    },
  },
  actions: {
    async selectBudget(budget: Budget) {
      this.currentBudget = budget;

      api.budgets.getRelatedLines(budget).then((res: Line[]) => {
        this.currentBudgetLines = res;
      });

      api.budgets.getRelatedObjective(budget).then((res: Objective) => {
        this.currentBudgetObjective = res;
      });
    },
    async selectDate(month: number, year: number) {
      const operationsStore = useOperationsStore();
      const start = moment().month(month).year(year).startOf("month");
      const end = moment().month(month).year(year).endOf("month");

      this.currentDateStartAt = start
      this.currentDateEndAt = end

      operationsStore.fetchAll(start, end);
    },
  },
});
