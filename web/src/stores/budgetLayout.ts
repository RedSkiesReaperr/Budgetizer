// Utilities
import {defineStore} from 'pinia'

export const useBudgetLayoutStore = defineStore('budgetLayout', {
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
