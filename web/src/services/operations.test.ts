import {describe, expect, it} from "vitest";
import {copyOperation} from "@/services/operations";
import {Operation} from "@/api/resources/operations";

describe("Calculations service", () => {
  describe("copyOperation()", () => {
    const original: Operation = {attributes: {amount: 289.33, date: "", label: "", pointed: true, opType: "", category: "", comment: ""}, id: "", type: "", links: {self: ""}}

    it("returns a real copy", () => {
      expect(copyOperation(original)).toStrictEqual(original)
    });
  });
});
