import {describe, expect, it} from "vitest";
import {copyLine, linesForTypes} from "@/services/lines";
import {Line} from "@/api/resources/lines";

describe("Lines service", () => {
  describe("copyLine()", () => {
    const original: Line = {
      attributes: {amount: 289.33, label: "", lineType: "", category: ""},
      id: "",
      type: "lines",
      links: {self: ""},
    }

    it("returns a real copy", () => {
      expect(copyLine(original)).toStrictEqual(original)
    });
  });

  describe("linesForTypes()", () => {
    const dataset: Line[] = [
      {
        attributes: {amount: 289.33, label: "", lineType: "TypeA", category: ""},
        id: "",
        type: "lines",
        links: {self: ""},
      },
      {
        attributes: {amount: 289.33, label: "", lineType: "TypeB", category: ""},
        id: "",
        type: "lines",
        links: {self: ""},
      },
      {
        attributes: {amount: 289.33, label: "", lineType: "TypeA", category: ""},
        id: "",
        type: "lines",
        links: {self: ""},
      }
    ]

    const expected: Line[] = [
      {
        attributes: {amount: 289.33, label: "", lineType: "TypeA", category: ""},
        id: "",
        type: "lines",
        links: {self: ""},
      },
      {
        attributes: {amount: 289.33, label: "", lineType: "TypeA", category: ""},
        id: "",
        type: "lines",
        links: {self: ""},
      }
    ]

    it("returns a real copy", () => {
      expect(linesForTypes(dataset, ["TypeA"])).toStrictEqual(expected)
    });
  })
});
