// stores/counter.spec.ts
import {setActivePinia, createPinia} from 'pinia'
import {expect, describe, beforeEach, it} from 'vitest'
import {useBudgetLayoutStore} from '@/stores/budgetLayout'

describe('budgetLayout Store', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('invertIsRailMode', () => {
    const store = useBudgetLayoutStore()
    expect(store.isRailMode).toBe(true)
    store.invertIsRailMode()
    expect(store.isRailMode).toBe(false)
  })

  it('invertIsExpanded', () => {
    const store = useBudgetLayoutStore()
    expect(store.isExpanded).toBe(false)
    store.invertIsExpanded()
    expect(store.isExpanded).toBe(true)
  })
})
