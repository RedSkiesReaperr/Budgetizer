import {describe, expect, it} from "vitest";
import {
  getCategoryById,
  getCategoryReadableKey,
  getCategoryTranslationKey,
  MISSING_CATEGORY,
  UNKNOWN_CATEGORY,
} from "./categories";
import {Category} from "@/api/resources/categories";

describe("Categories service", () => {
  const category1: Category = {
    id: "1",
    type: "categories",
    links: {
      self: "my_example_category_link"
    },
    attributes: {
      key: "example_abcdefg2",
      color: "#9e9e9e",
      icon: "mdi-example"
    }
  }

  const category2: Category = {
    id: "2",
    type: "categories",
    links: {
      self: "my_example_category_link"
    },
    attributes: {
      key: "hello_world",
      color: "#9e9e9e",
      icon: "mdi-hello"
    }
  }

  const category89: Category = {
    id: "89",
    type: "categories",
    links: {
      self: "my_example_category_link"
    },
    attributes: {
      key: "example_abcdefg2",
      color: "#9e9e9e",
      icon: "mdi-example"
    }
  }

  const categories: Category[] = [category1, category2, category89]

  describe("getCategoryById()", () => {
    describe("when category id is null", () => {
      it("returns XXX category object", () => {
        expect(getCategoryById(null, categories)).toStrictEqual(MISSING_CATEGORY);
      })
    })

    describe("when category id is of type number", () => {
      it("returns XXX category object", () => {
        expect(getCategoryById(2, categories)).toStrictEqual(category2);
      })
    })

    describe("when category id is of type string", () => {
      it("returns XXX category object", () => {
        expect(getCategoryById("89", categories)).toStrictEqual(category89);
      })
    })

    describe("when category is unknown", () => {
      it("returns XXX category object", () => {
        expect(getCategoryById(999, categories)).toStrictEqual(UNKNOWN_CATEGORY);
      })
    })
  });

  describe("getCategoryTranslationKey()", () => {
    it("returns right translation key for category", () => {
      expect(getCategoryTranslationKey(category1)).toStrictEqual(`operation.categories.example_abcdefg2`);
    });
  });

  describe("getCategoryReadableKey()", () => {
    it("returns right color for each Category", () => {
      expect(getCategoryReadableKey(category1)).toStrictEqual("Example abcdefg2");
    });
  });
});
