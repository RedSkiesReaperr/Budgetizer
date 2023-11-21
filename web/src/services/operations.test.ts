import {describe, expect, it} from "vitest";
import {copyOperation, operationsForCategories, operationsForDay} from "@/services/operations";
import {Operation} from "@/api/resources/operations";
import moment from "moment/moment";

describe("Operations service", () => {
  describe("copyOperation()", () => {
    const original: Operation = {
      attributes: {
        amount: 289.33,
        date: "",
        label: "",
        pointed: true,
        opType: "",
        category: "",
        comment: ""
      }, id: "", type: "", links: {self: ""}
    }

    it("returns a real copy", () => {
      expect(copyOperation(original)).toStrictEqual(original)
    });
  });

  describe("operationsForCategories()", () => {
    const dataset: Operation[] = [
      {
        attributes: {
          amount: 289.33,
          date: "",
          label: "",
          pointed: true,
          opType: "",
          category: "CategoryA",
          comment: ""
        },
        id: "",
        type: "",
        links: {self: ""}
      },
      {
        attributes: {
          amount: 289.33,
          date: "",
          label: "",
          pointed: true,
          opType: "",
          category: "CategoryB",
          comment: ""
        },
        id: "",
        type: "",
        links: {self: ""}
      },
      {
        attributes: {amount: 76.34, date: "", label: "", pointed: true, opType: "", category: "CategoryA", comment: ""},
        id: "",
        type: "",
        links: {self: ""}
      },
    ]

    const expected: Operation[] = [
      {
        attributes: {
          amount: 289.33,
          date: "",
          label: "",
          pointed: true,
          opType: "",
          category: "CategoryA",
          comment: ""
        },
        id: "",
        type: "",
        links: {self: ""}
      },
      {
        attributes: {amount: 76.34, date: "", label: "", pointed: true, opType: "", category: "CategoryA", comment: ""},
        id: "",
        type: "",
        links: {self: ""}
      },
    ]

    it("returns a real copy", () => {
      expect(operationsForCategories(dataset, ["CategoryA"])).toStrictEqual(expected)
    });
  })

  describe("operationsForDay()", () => {
    const dataset: Operation[] = [
      {
        attributes: {
          amount: 289.33,
          date: "2023-08-30T00:00:00.000Z",
          label: "",
          pointed: true,
          opType: "",
          category: "CategoryA",
          comment: ""
        },
        id: "",
        type: "",
        links: {self: ""}
      },
      {
        attributes: {
          amount: 289.33,
          date: "2023-08-31T00:00:00.000Z",
          label: "",
          pointed: true,
          opType: "",
          category: "CategoryB",
          comment: ""
        },
        id: "",
        type: "",
        links: {self: ""}
      },
      {
        attributes: {
          amount: 76.34,
          date: "2023-08-20T00:00:00.000Z",
          label: "",
          pointed: true,
          opType: "",
          category: "CategoryA",
          comment: ""
        },
        id: "",
        type: "",
        links: {self: ""}
      },
    ]

    const expected: Operation[] = [
      {
        attributes: {
          amount: 289.33,
          date: "2023-08-31T00:00:00.000Z",
          label: "",
          pointed: true,
          opType: "",
          category: "CategoryB",
          comment: ""
        },
        id: "",
        type: "",
        links: {self: ""}
      }
    ]

    it("returns a real copy", () => {
      const date = moment('2023-08-31', 'YYYY-MM-DD')

      expect(operationsForDay(dataset, date)).toStrictEqual(expected)
    });
  })
});
