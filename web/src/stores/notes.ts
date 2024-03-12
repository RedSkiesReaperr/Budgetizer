import api from "@/api";
import {defineStore} from "pinia";
import {Note} from "@/api/resources/notes";
import moment from "moment/moment";

export const useNotesStore = defineStore("notes", {
  state: () => ({
    notes: [] as Note[],
    fetching: false,
  }),
  actions: {
    async fetchAll(referenceDate: moment.Moment) {
      this.fetching = true;
      const month = referenceDate.month() + 1
      const year = referenceDate.year()

      api.notes.getAll(month, year)
        .then((res: Note[]) => this.notes = res)
        .finally(() => this.fetching = false);
    },
  }
});
