import {describe, it, expect} from "vitest";
import moment from "moment";
import {daysInRangeAsMoment, daysInRangeAsStr} from "@/services/dates";

describe("Dates service", () => {
  const startDate = moment("2023-01-21")
  const endDate = moment("2023-01-27")

  describe("daysInRangeAsMoment()", () => {
    it("returns range days as moment objects", () => {
      const res = daysInRangeAsMoment(startDate, endDate) //daysInRange(startDate, endDate)
      const expected = [
        moment("2023-01-21"),
        moment("2023-01-22"),
        moment("2023-01-23"),
        moment("2023-01-24"),
        moment("2023-01-25"),
        moment("2023-01-26"),
        moment("2023-01-27")
      ]

      expected.forEach((i, index) => {
        expect(i.isSame(res[index])).toBeTruthy()
      })
    })
  })

  describe("daysInRangeAsStr()", () => {
    it("returns range days as string, following given format", () => {
      const res = daysInRangeAsStr(startDate, endDate, "MM-YYYY-DD") //daysInRange(startDate, endDate, "MM-YYYY-DD")

      expect(res).toStrictEqual([
        "01-2023-21",
        "01-2023-22",
        "01-2023-23",
        "01-2023-24",
        "01-2023-25",
        "01-2023-26",
        "01-2023-27"
      ])
    })
  })
})
