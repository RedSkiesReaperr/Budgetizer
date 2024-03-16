// stores/counter.spec.ts
import {setActivePinia, createPinia} from "pinia";
import {expect, describe, beforeEach, it, vi} from "vitest";
import LinesRequests, {Line} from "@/api/resources/lines";
import {useLinesStore} from "@/stores/lines";

describe("lines Store", () => {
  const lines: Line[] = [
    {
      id: "1",
      type: "lines",
      links: {
        self: "self_link",
      },
      attributes: {
        label: "Line #",
        amount: 53.34,
        lineType: "income",
        categoryId: 1,
      },
    }
  ];

  beforeEach(() => {
    setActivePinia(createPinia());

    vi.spyOn(LinesRequests, "getAll").mockImplementationOnce(() =>
      Promise.resolve<Line[]>(lines)
    );
  });

  describe("fetchAll", () => {
    it("fills lines", async () => {
      const store = useLinesStore();
      expect(store.lines).toStrictEqual([]);
      await store.fetchAll();
      expect(store.lines).toStrictEqual(lines);
    });
  });
});
