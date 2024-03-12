import {defineStore} from "pinia";
import api from "@/api";
import {Line} from "@/api/resources/lines";

export const useLinesStore = defineStore("lines", {
  state: () => ({
    lines: [] as Line[],
    fetching: false,
  }),
  actions: {
    async fetchAll() {
      this.fetching = true

      api.lines.getAll()
        .then((res: Line[]) => this.lines = res)
        .finally(() => this.fetching = false)
    },
  },
})
