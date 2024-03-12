import {setActivePinia, createPinia} from "pinia";
import {expect, describe, beforeEach, it, vi} from "vitest";
import ObjectivesRequests, {Objective} from "@/api/resources/objectives";
import {useObjectivesStore} from "@/stores/objectives";

describe("objectives Store", () => {
  const objectives: Objective[] = [
    {
      id: "1",
      type: "objectives",
      links: {
        self: "self_link",
      },
      attributes: {
        vital: 60,
        nonEssential: 94,
        saving: 44,
      },
    }
  ];

  beforeEach(() => {
    setActivePinia(createPinia());

    vi.spyOn(ObjectivesRequests, "getAll").mockImplementationOnce(() =>
      Promise.resolve<Objective[]>(objectives)
    );
  });

  describe("fetchAll", () => {
    it("fills objective", async () => {


      const store = useObjectivesStore();
      expect(store.objective).toStrictEqual({});
      await store.fetchAll();
      expect(store.objective).toStrictEqual(objectives[0]);
    });
  });

  describe("getters", () => {
    describe("vital", () => {
      it("returns correct value", () => {
        const store = useObjectivesStore()
        store.$patch({objective: objectives.at(0)})
        expect(store.vital).toEqual(60)
      })
    })

    describe("nonEssential", () => {
      it("returns correct value", () => {
        const store = useObjectivesStore()
        store.$patch({objective: objectives.at(0)})
        expect(store.nonEssential).toEqual(94)
      })
    })

    describe("saving", () => {
      it("returns correct value", () => {
        const store = useObjectivesStore()
        store.$patch({objective: objectives.at(0)})
        expect(store.saving).toEqual(44)
      })
    })
  })
});
