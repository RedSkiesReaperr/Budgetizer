// stores/counter.spec.ts
import {setActivePinia, createPinia} from "pinia";
import {expect, describe, beforeEach, it, vi} from "vitest";
import {useForecastsStore} from "@/stores/forecasts";
import ForecastsRequests, {Forecast} from "@/api/resources/forecasts";

describe("forecasts Store", () => {
  const forecast: Forecast = {
    type: "forecasts",
    attributes: {
      income: 873.3,
      vital: 8320.9,
      nonEssential: 12245.09,
      saving: 145.38,
      vitalDiff: 8991.33,
      nonEssentialDiff: 129.93,
      savingDiff: 738.22,
      vitalDiffPercentage: 12.98,
      nonEssentialDiffPercentage: 234.79,
      savingDiffPercentage: 983.22,
    },
  };

  beforeEach(() => {
    setActivePinia(createPinia());
  });

  describe("fetch", () => {
    it("fills forecasts", async () => {
      vi.spyOn(ForecastsRequests, "get").mockImplementationOnce(() =>
        Promise.resolve<Forecast>(forecast)
      );

      const store = useForecastsStore();
      expect(store.forecasts).toStrictEqual({});
      await store.fetch();
      expect(store.forecasts).toStrictEqual(forecast);
    });
  });

  describe("getters", () => {
    describe("income", () => {
      it("returns correct value", () => {
        const store = useForecastsStore()
        store.$patch({forecasts: forecast})
        expect(store.income).toEqual(873.3)
      })
    })

    describe("vital", () => {
      it("returns correct value", () => {
        const store = useForecastsStore()
        store.$patch({forecasts: forecast})
        expect(store.vital).toEqual(8320.9)
      })
    })

    describe("nonEssential", () => {
      it("returns correct value", () => {
        const store = useForecastsStore()
        store.$patch({forecasts: forecast})
        expect(store.nonEssential).toEqual(12245.09)
      })
    })

    describe("saving", () => {
      it("returns correct value", () => {
        const store = useForecastsStore()
        store.$patch({forecasts: forecast})
        expect(store.saving).toEqual(145.38)
      })
    })

    describe("vitalDiff", () => {
      it("returns correct value", () => {
        const store = useForecastsStore()
        store.$patch({forecasts: forecast})
        expect(store.vitalDiff).toEqual(8991.33)
      })
    })

    describe("nonEssentialDiff", () => {
      it("returns correct value", () => {
        const store = useForecastsStore()
        store.$patch({forecasts: forecast})
        expect(store.nonEssentialDiff).toEqual(129.93)
      })
    })

    describe("savingDiff", () => {
      it("returns correct value", () => {
        const store = useForecastsStore()
        store.$patch({forecasts: forecast})
        expect(store.savingDiff).toEqual(738.22)
      })
    })

    describe("vitalDiffPercentage", () => {
      it("returns correct value", () => {
        const store = useForecastsStore()
        store.$patch({forecasts: forecast})
        expect(store.vitalDiffPercentage).toEqual(12.98)
      })
    })

    describe("nonEssentialDiffPercentage", () => {
      it("returns correct value", () => {
        const store = useForecastsStore()
        store.$patch({forecasts: forecast})
        expect(store.nonEssentialDiffPercentage).toEqual(234.79)
      })
    })

    describe("savingDiffPercentage", () => {
      it("returns correct value", () => {
        const store = useForecastsStore()
        store.$patch({forecasts: forecast})
        expect(store.savingDiffPercentage).toEqual(983.22)
      })
    })
  })
});
