import {describe, expect, it} from "vitest";
import {
  copyOperation,
  getOperationsByCategory,
  getOperationsUncategorized,
  getOperationsByDay
} from "@/services/operations";
import {Operation} from "@/api/resources/operations";
import moment from "moment/moment";
import {Category} from "@/api/resources/categories";

describe("Operations service", () => {
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

  describe("copyOperation()", () => {
    const original: Operation = {
      attributes: {
        amount: 289.33,
        date: "",
        label: "",
        pointed: true,
        opType: "",
        categoryId: -1,
        comment: ""
      }, id: "", type: "", links: {self: ""}
    }

    it("returns a real copy", () => {
      expect(copyOperation(original)).toStrictEqual(original)
    });
  });

  describe("getOperationsByCategory()", () => {
    const dataset: Operation[] = [
      {
        attributes: {
          amount: 289.33,
          date: "",
          label: "",
          pointed: true,
          opType: "",
          categoryId: 1,
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
          categoryId: 2,
          comment: ""
        },
        id: "",
        type: "",
        links: {self: ""}
      },
      {
        attributes: {amount: 76.34, date: "", label: "", pointed: true, opType: "", categoryId: 1, comment: ""},
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
          categoryId: 1,
          comment: ""
        },
        id: "",
        type: "",
        links: {self: ""}
      },
      {
        attributes: {amount: 76.34, date: "", label: "", pointed: true, opType: "", categoryId: 1, comment: ""},
        id: "",
        type: "",
        links: {self: ""}
      },
    ]

    it("returns only category operations", () => {
      expect(getOperationsByCategory(category1, dataset)).toStrictEqual(expected)
    });
  })

  describe("getOperationsUncategorized()", () => {
    const dataset: Operation[] = [
      {
        attributes: {
          amount: 289.33,
          date: "",
          label: "",
          pointed: true,
          opType: "",
          categoryId: null,
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
          categoryId: 2,
          comment: ""
        },
        id: "",
        type: "",
        links: {self: ""}
      },
      {
        attributes: {amount: 76.34, date: "", label: "", pointed: true, opType: "", categoryId: 1, comment: ""},
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
          categoryId: null,
          comment: ""
        },
        id: "",
        type: "",
        links: {self: ""}
      }
    ]

    it("returns only uncategorized operations", () => {
      expect(getOperationsUncategorized(dataset)).toStrictEqual(expected)
    });
  })

  describe("getOperationsByDay()", () => {
    const dataset: Operation[] = [
      {
        attributes: {
          amount: 289.33,
          date: "2023-08-30T00:00:00.000Z",
          label: "",
          pointed: true,
          opType: "",
          categoryId: 1,
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
          categoryId: 2,
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
          categoryId: 1,
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
          categoryId: 2,
          comment: ""
        },
        id: "",
        type: "",
        links: {self: ""}
      }
    ]

    it("returns a real copy", () => {
      const date = moment('2023-08-31', 'YYYY-MM-DD')

      expect(getOperationsByDay(date, dataset)).toStrictEqual(expected)
    });
  })
});
