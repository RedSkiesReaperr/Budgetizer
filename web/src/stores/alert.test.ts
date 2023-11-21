// stores/counter.spec.ts
import {setActivePinia, createPinia} from 'pinia'
import {expect, describe, beforeEach, it} from 'vitest'
import { AlertType, useAlertStore } from './alert'

describe('alert Store', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('reset', () => {
    const store = useAlertStore()
    store.displayed = true
    store.title = "My title"
    store.message = "My message"
    store.type = AlertType.Success

    store.reset()
    
    expect(store.displayed).toEqual(false)
    expect(store.title).toEqual("")
    expect(store.message).toEqual("")
    expect(store.type).toEqual(AlertType.Error)
  })

  it('show', async () => {
    const store = useAlertStore()
    await store.show(AlertType.Warning, "Warning!", "Be aware!")

    expect(store.displayed).toEqual(true)
    expect(store.title).toEqual("Warning!")
    expect(store.message).toEqual("Be aware!")
    expect(store.type).toEqual(AlertType.Warning)
  })
  
  it('hide', async () => {
    const store = useAlertStore()
    store.displayed = true
    store.title = "My title"
    store.message = "My message"
    store.type = AlertType.Success

    await store.hide()

    expect(store.displayed).toEqual(false)
    expect(store.title).toEqual("")
    expect(store.message).toEqual("")
    expect(store.type).toEqual(AlertType.Error)

  })
})
