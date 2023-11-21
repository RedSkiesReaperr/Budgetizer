import {describe, expect, it} from "vitest";
import { formatNumber } from "./formatters";

describe("Formatters service", () => {
    describe("formatNumber", () => {
        const inputs = [23, 23.93, 233333.44, 88888888888.25]
        const expected = ["23.00", "23.93", "233,333.44", "88,888,888,888.25"]

        it("format numbers", () => {
            inputs.forEach((input, i) => {
                expect(formatNumber(input)).toEqual(expected[i])
            })
        })
    })
})
