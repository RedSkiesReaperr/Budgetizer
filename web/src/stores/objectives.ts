import {defineStore} from "pinia";
import api from "@/api";
import {Objective} from "@/api/resources/objectives";

export const useObjectivesStore = defineStore("objectives", {
  state: () => ({
    objective: {} as Objective,
    fetching: false,
  }),
  getters: {
    vital: (state): number => state.objective.attributes.vital,
    nonEssential: (state): number => state.objective.attributes.nonEssential,
    saving: (state): number => state.objective.attributes.saving,
  },
  actions: {
    async fetchAll() {
      this.fetching = true

      api.objectives.getAll()
        .then((res: Objective[]) => this.objective = res[0]) // Currently selecting first objective by default, waiting for objective selection feature
        .finally(() => this.fetching = false)
    },
  },
})
