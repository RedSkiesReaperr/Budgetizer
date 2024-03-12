import {defineStore} from 'pinia'

export const useDashboardLayoutStore = defineStore('dashboardLayout', {
  state: () => ({
    isRailMode: true,
    isExpanded: false
  }),
  actions: {
    invertIsRailMode() {
      this.isRailMode = !this.isRailMode
    },
    invertIsExpanded() {
      this.isExpanded = !this.isExpanded
    }
  }
})
