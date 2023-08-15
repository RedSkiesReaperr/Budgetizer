import { describe, expect, it } from "vitest";
import {
  percentageToValue,
  valueToPercentage,
  variationPercentage,
} from "./calculations";

describe("Calculations service", () => {
  describe("percentageToValue()", () => {
    it("returns correct value", () => {
      expect(percentageToValue(23, 4978)).toEqual(1144.94);
    });
  });

  describe("valueToPercentage()", () => {
    it("returns correct percentage", () => {
      expect(valueToPercentage(78, 67522)).toEqual(0.11551790527531768);
    });
  });

  describe("variationPercentage()", () => {
    it("returns correct variation", () => {
      expect(variationPercentage(65, 785)).toEqual(1107.6923076923076);
    });
  });
});
