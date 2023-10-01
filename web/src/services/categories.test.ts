import { describe, expect, it } from "vitest";
import {
  getCategoryColor,
  getCategoryIcon,
  getCategoryTranslationKey,
} from "./categories";

describe("Categories service", () => {
  describe("getCategoryColor()", () => {
    const expectations = [
      { rawCategory: "to_categorize", expected: "#9e9e9e" },
      { rawCategory: "home", expected: "#2980b9" },
      { rawCategory: "bank", expected: "#d35400" },
      { rawCategory: "shopping", expected: "#e74c3c" },
      { rawCategory: "food", expected: "#f1c40f" },
      { rawCategory: "subscriptions", expected: "#9b59b6" },
      { rawCategory: "auto_transport", expected: "#1abc9c" },
      { rawCategory: "beauty_care", expected: "#ff9ff3" },
      { rawCategory: "taxes", expected: "#bdc3c7" },
      { rawCategory: "salary", expected: "#27ae60" },
      { rawCategory: "this_is_unknown", expected: "#9e9e9e" },
    ];

    it("returns right color for each Category", () => {
      expectations.forEach((obj) => {
        expect(getCategoryColor(obj.rawCategory)).toStrictEqual(obj.expected);
      });
    });
  });

  describe("getCategoryIcon()", () => {
    const expectations = [
      { rawCategory: "to_categorize", expected: "mdi-shape-plus-outline" },
      { rawCategory: "home", expected: "mdi-home-circle-outline" },
      { rawCategory: "bank", expected: "mdi-bank-outline" },
      { rawCategory: "shopping", expected: "mdi-shopping-outline" },
      { rawCategory: "food", expected: "mdi-food" },
      { rawCategory: "subscriptions", expected: "mdi-cash-sync" },
      { rawCategory: "auto_transport", expected: "mdi-plane-car" },
      { rawCategory: "beauty_care", expected: "mdi-star-four-points-outline" },
      { rawCategory: "taxes", expected: "mdi-cash-multiple" },
      { rawCategory: "salary", expected: "mdi-cash-100" },
      { rawCategory: "this_is_unknown", expected: "mdi-crosshairs-question" },
    ];

    it("returns right color for each Category", () => {
      expectations.forEach((obj) => {
        expect(getCategoryIcon(obj.rawCategory)).toStrictEqual(obj.expected);
      });
    });
  });

  describe("getCategoryTranslationKey()", () => {
    const expectations = [
      {
        rawCategory: "to_categorize",
        expected: "operation.categories.to_categorize",
      },
      { rawCategory: "home", expected: "operation.categories.home" },
      { rawCategory: "bank", expected: "operation.categories.bank" },
      { rawCategory: "shopping", expected: "operation.categories.shopping" },
      { rawCategory: "food", expected: "operation.categories.food" },
      {
        rawCategory: "subscriptions",
        expected: "operation.categories.subscriptions",
      },
      {
        rawCategory: "auto_transport",
        expected: "operation.categories.auto_transport",
      },
      {
        rawCategory: "beauty_care",
        expected: "operation.categories.beauty_care",
      },
      { rawCategory: "taxes", expected: "operation.categories.taxes" },
      { rawCategory: "salary", expected: "operation.categories.salary" },
      {
        rawCategory: "this_is_unknown",
        expected: "operation.categories.unknown",
      },
    ];

    it("returns right color for each Category", () => {
      expectations.forEach((obj) => {
        expect(getCategoryTranslationKey(obj.rawCategory)).toStrictEqual(
          obj.expected
        );
      });
    });
  });
});
