// stores/counter.spec.ts
import {setActivePinia, createPinia} from "pinia";
import {expect, describe, beforeEach, it, vi} from "vitest";
import {useCategoriesStore} from "@/stores/categories";
import CategoriesRequests, {Category} from "@/api/resources/categories";

describe("categories Store", () => {
  const category1: Category = {
    id: "1",
    type: "categories",
    links: {
      self: "self_url",
    },
    attributes: {
      key: "salary",
      color: "#H3H98S",
      icon: "mdi-xxx-xxx",
    },
  };

  const category2: Category = {
    id: "2",
    type: "categories",
    links: {
      self: "self_url",
    },
    attributes: {
      key: "key2",
      color: "#H3H98S",
      icon: "mdi-xxx-xxx",
    },
  };

  const allCategories: Category[] = [category1, category2];

  beforeEach(() => {
    setActivePinia(createPinia());
  });

  describe("getter expenseCategories", () => {
    it("returns only expense categories", async () => {
      vi.spyOn(CategoriesRequests, "getAll").mockImplementationOnce(() =>
        Promise.resolve<Category[]>(allCategories)
      );

      const store = useCategoriesStore();
      await store.fetchAll()
      expect(store.expenseCategories).toStrictEqual([category2])
    })
  })

  describe("fetchAll", () => {
    it("fills categories", async () => {
      vi.spyOn(CategoriesRequests, "getAll").mockImplementationOnce(() =>
        Promise.resolve<Category[]>(allCategories)
      );

      const store = useCategoriesStore();
      expect(store.categories).toStrictEqual([]);
      await store.fetchAll();
      expect(store.categories).toStrictEqual(allCategories);
    });
  });
});
