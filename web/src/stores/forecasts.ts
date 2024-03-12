import {defineStore} from "pinia";
import api from "@/api";
import {Forecast} from "@/api/resources/forecasts";

export const useForecastsStore = defineStore("forecasts", {
  state: () => ({
    forecasts: {} as Forecast,
    fetching: false,
  }),
  getters: {
    income: (state): number => state.forecasts.attributes.income,
    vital: (state): number => state.forecasts.attributes.vital,
    nonEssential: (state): number => state.forecasts.attributes.nonEssential,
    saving: (state): number => state.forecasts.attributes.saving,
    vitalDiff: (state): number => state.forecasts.attributes.vitalDiff,
    nonEssentialDiff: (state): number => state.forecasts.attributes.nonEssentialDiff,
    savingDiff: (state): number => state.forecasts.attributes.savingDiff,
    vitalDiffPercentage: (state): number => state.forecasts.attributes.vitalDiffPercentage,
    nonEssentialDiffPercentage: (state): number => state.forecasts.attributes.nonEssentialDiffPercentage,
    savingDiffPercentage: (state): number => state.forecasts.attributes.savingDiffPercentage,
  },
  actions: {
    async fetch() {
      this.fetching = true

      api.forecasts.get()
        .then((res: Forecast) => this.forecasts = res)
        .finally(() => this.fetching = false)
    },
  },
})
