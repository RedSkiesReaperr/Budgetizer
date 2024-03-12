// stores/counter.spec.ts
import {setActivePinia, createPinia} from 'pinia'
import {expect, describe, beforeEach, it} from 'vitest'
import {useDashboardLayoutStore} from '@/stores/dashboardLayout'

describe('dashboardLayout Store', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('invertIsRailMode', () => {
    const store = useDashboardLayoutStore()
    expect(store.isRailMode).toBe(true)
    store.invertIsRailMode()
    expect(store.isRailMode).toBe(false)
  })

  it('invertIsExpanded', () => {
    const store = useDashboardLayoutStore()
    expect(store.isExpanded).toBe(false)
    store.invertIsExpanded()
    expect(store.isExpanded).toBe(true)
  })
})
