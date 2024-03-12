import {describe, expect, it} from "vitest";
import {
  percentageToValue, sum,
  valueToPercentage,
  variationPercentage,
} from "./calculations";
import {Operation} from "@/api/resources/operations";
import {Line} from "@/api/resources/lines";

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

  describe("sum()", () => {
    describe("sum<Operation>()", () => {
      const operations: Operation[] = [
        {attributes: {amount: 289.33, date: "", label: "", pointed: true, opType: "", category: "", comment: ""}, id: "", type: "", links: {self: ""}},
        {attributes: {amount: 98.13, date: "", label: "", pointed: true, opType: "", category: "", comment: ""}, id: "", type: "", links: {self: ""}},
        {attributes: {amount: 3.92, date: "", label: "", pointed: true, opType: "", category: "", comment: ""}, id: "", type: "", links: {self: ""}},
      ]
      it("returns correct sum", () => {
        expect(sum(operations)).toEqual(391.38);
      });
    })

    describe("sum<Line>()", () => {
      const lines: Line[] = [
        {attributes: {amount: 982.73, label: "", category: "", lineType: ""}, id: "", links: {self: ""}, type: "lines"},
        {attributes: {amount: 273.02, label: "", category: "", lineType: ""}, id: "", links: {self: ""}, type: "lines"},
        {attributes: {amount: 94.87, label: "", category: "", lineType: ""}, id: "", links: {self: ""}, type: "lines"},
      ]

      it("returns correct sum", () => {
        expect(sum(lines)).toEqual(1350.62);
      });
    })
  });
});
