// stores/counter.spec.ts
import { setActivePinia, createPinia } from "pinia";
import { expect, describe, beforeEach, it, vi } from "vitest";
import { useCategoriesStore } from "@/stores/categories";
import CategoriesRequests, { Category } from "@/api/resources/categories";

describe("categories Store", () => {
  const category: Category = {
    id: "1",
    type: "categories",
    links: {
      self: "self_url",
    },
    attributes: {
      key: "key1",
      color: "#H3H98S",
      icon: "mdi-xxx-xxx",
    },
  };

  beforeEach(() => {
    setActivePinia(createPinia());
  });

  describe("fetchAll", () => {
    it("fills categories", async () => {
      vi.spyOn(CategoriesRequests, "getAll").mockImplementationOnce(() =>
        Promise.resolve<Category[]>([category])
      );

      const store = useCategoriesStore();
      expect(store.categories).toStrictEqual([]);
      await store.fetchAll();
      expect(store.categories).toStrictEqual([category]);
    });
  });
});
