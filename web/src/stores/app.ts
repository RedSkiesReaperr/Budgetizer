import {defineStore} from "pinia";
import moment from "moment";
import {useOperationsStore} from "./operations";
import {useStorage} from '@vueuse/core'
import {useNotesStore} from "@/stores/notes";
import {useCategoriesStore} from "@/stores/categories";
import {useDashboardLayoutStore} from "@/stores/dashboardLayout";
import {useAlertStore} from "@/stores/alert";
import api from "@/api";
import {useForecastsStore} from "@/stores/forecasts";
import {useObjectivesStore} from "@/stores/objectives";
import {useLinesStore} from "@/stores/lines";

const categoriesStore = useCategoriesStore();
const dashboardLayoutStore = useDashboardLayoutStore();
const operationsStore = useOperationsStore();
const alertStore = useAlertStore();
const notesStore = useNotesStore();
const forecastsStore = useForecastsStore();
const objectivesStore = useObjectivesStore();
const linesStore = useLinesStore();

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
      const start = moment().month(month).year(year).startOf("month");
      const end = moment().month(month).year(year).endOf("month");

      this.currentDateStartAt = start
      this.currentDateEndAt = end

      await operationsStore.fetchAll(start, end);
      await notesStore.fetchAll(start);
    },
    async logout() {
      api.auth.signOut().finally(() => {
        this.$reset()
        categoriesStore.$reset()
        dashboardLayoutStore.$reset()
        operationsStore.$reset()
        alertStore.$reset()
        notesStore.$reset()
        forecastsStore.$reset()
        objectivesStore.$reset()
        linesStore.$reset()
      })
    }
  },
});
