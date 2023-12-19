// Utilities
import {defineStore} from "pinia";
import {Budget, Objective} from "@/api/resources/budgets";
import api from "@/api";
import {Line} from "@/api/resources/lines";
import {
  percentageToValue, sum,
  variationPercentage,
} from "@/services/calculations";
import moment from "moment";
import {useOperationsStore} from "./operations";
import {useStorage} from '@vueuse/core'
import {linesForTypes} from "@/services/lines";
import {useNotesStore} from "@/stores/notes";
import notes from "@/api/resources/notes";

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
    // Income
    forecastIncome: (state): number => sum(linesForTypes(state.currentBudgetLines, ["income"])),
    forecastVital: (state): number => sum(linesForTypes(state.currentBudgetLines, ["vital"])),
    forecastNonEssential: (state): number => sum(linesForTypes(state.currentBudgetLines, ["non_essential"])),
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
      const notesStore = useNotesStore();
      const start = moment().month(month).year(year).startOf("month");
      const end = moment().month(month).year(year).endOf("month");

      this.currentDateStartAt = start
      this.currentDateEndAt = end

      operationsStore.fetchAll(start, end);
      notesStore.fetchAll(start);
    },
  },
});
