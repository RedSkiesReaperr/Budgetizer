import {defineStore} from "pinia";
import moment from "moment";
import {useOperationsStore} from "./operations";
import {useStorage} from '@vueuse/core'
import {useNotesStore} from "@/stores/notes";

export const useAppStore = defineStore("app", {
  state: () => ({
    currentDateStartAt: useStorage('currentDateStartAt', moment().startOf("month"), undefined, {
      serializer: {
        read: (v: string): moment.Moment => moment(v, "YYYY-DD-MM"),
        write: (v: moment.Moment): string => v.format("YYYY-DD-MM")
      }
    }),
    currentDateEndAt: useStorage('currentDateEndAt', moment().endOf("month"), undefined, {
      serializer: {
        read: (v: string): moment.Moment => moment(v, "YYYY-DD-MM"),
        write: (v: moment.Moment): string => v.format("YYYY-DD-MM")
      }
    }),
  }),
  actions: {
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
