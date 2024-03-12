export function formatNumber(number: number): string {
  return number.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',')
}

export function formatAmount(number: number): string {
  return `${formatNumber(number)} €`
}

export function formatPercentage(number: number): string {
  const perc = formatNumber(number);

  return number >= 0 ? `+${perc}%` : `${perc}%`;
}
