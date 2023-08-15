export function percentageToValue(percentage: number, value: number): number {
  return (percentage * value) / 100;
}

export function valueToPercentage(value: number, total: number): number {
  return (value * 100) / total;
}

export function variationPercentage(v1: number, v2: number): number {
  return ((v2 - v1) / v1) * 100;
}
