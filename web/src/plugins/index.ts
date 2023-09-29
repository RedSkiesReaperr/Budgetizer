/**
 * plugins/index.ts
 *
 * Automatically included in `./src/main.ts`
 */

// Plugins
import {loadFonts} from './webfontloader'
import vuetify from './vuetify'
import pinia from '../stores'
import router from '../router'
import i18n from "@/plugins/vue-i18n";
import VueApexCharts from "vue3-apexcharts";
import VueDatePicker from '@vuepic/vue-datepicker';
import '@vuepic/vue-datepicker/dist/main.css'
import 'moment/dist/locale/fr';

// Types
import type {App} from 'vue'

export function registerPlugins(app: App) {
  loadFonts()
  app
    .use(vuetify)
    .use(router)
    .use(pinia)
    .use(i18n)
    .use(VueApexCharts)
    .component('VueDatePicker', VueDatePicker)
}
