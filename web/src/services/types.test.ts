import { describe, expect, it } from "vitest";
import { getTypeColor, getTypeIcon, getTypeTranslationKey } from "./types";

describe("Type service", () => {
  describe("getTypeColor()", () => {
    const expectations = [
      { rawType: "income", expected: "#4caf50" },
      { rawType: "vital", expected: "#9b59b6" },
      { rawType: "non_essential", expected: "#3498db" },
      { rawType: "this_is_unknown", expected: "#9e9e9e" },
      { rawType: "saving", expected: "#4caf50" },
    ];

    it("returns right color for each type", () => {
      expectations.forEach((obj) => {
        expect(getTypeColor(obj.rawType)).toStrictEqual(obj.expected);
      });
    });
  });

  describe("getTypeIcon()", () => {
    const expectations = [
      { rawType: "income", expected: "mdi-location-enter" },
      { rawType: "vital", expected: "mdi-pulse" },
      { rawType: "non_essential", expected: "mdi-asterisk" },
      { rawType: "this_is_unknown", expected: "mdi-crosshairs-question" },
      { rawType: "saving", expected: "mdi-cash-100" },
    ];

    it("returns right color for each type", () => {
      expectations.forEach((obj) => {
        expect(getTypeIcon(obj.rawType)).toStrictEqual(obj.expected);
      });
    });
  });

  describe("getTypeTranslationKey()", () => {
    const expectations = [
      { rawType: "income", expected: "operation.types.income" },
      { rawType: "vital", expected: "operation.types.vital" },
      { rawType: "non_essential", expected: "operation.types.non_essential" },
      { rawType: "this_is_unknown", expected: "operation.types.unknown" },
      { rawType: "saving", expected: "saving" },
    ];

    it("returns right color for each type", () => {
      expectations.forEach((obj) => {
        expect(getTypeTranslationKey(obj.rawType)).toStrictEqual(obj.expected);
      });
    });
  });
});
