import { Line } from "@/api/resources/budgets";

//
// types can be "vital", "non_essential" or "income"
//

export function getForecastTypesAmount(types: string[], lines: Line[]): number {
  return lines
    .filter((l) => types.includes(l.attributes.lineType))
    .reduce((sum, l) => sum + l.attributes.amount, 0);
}

export function getForecastSavingAmount(lines: Line[]): number {
  const incomes = getForecastTypesAmount(["income"], lines);
  const expenses = getForecastTypesAmount(["vital", "non_essential"], lines);

  return incomes - expenses;
}

export function getForecastTypeMaxValue(
  percentage: number,
  lines: Line[]
): number {
  const incomes = getForecastTypesAmount(["income"], lines);

  console.log((percentage * incomes) / 100);
  return (percentage * incomes) / 100;
}
