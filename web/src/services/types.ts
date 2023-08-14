export function getTypeColor(rawType: string): string {
  switch (rawType) {
    case "saving":
    case "income":
      return "#4caf50";
    case "vital":
      return "#9b59b6";
    case "non_essential":
      return "#3498db";
    default:
      return "#9e9e9e";
  }
}

export function getTypeIcon(rawType: string): string {
  switch (rawType) {
    case "income":
      return "mdi-location-enter";
    case "vital":
      return "mdi-pulse";
    case "non_essential":
      return "mdi-asterisk";
    case "saving":
      return "mdi-cash-100";
    default:
      return "mdi-crosshairs-question";
  }
}

export function getTypeTranslationKey(rawType: string): string {
  switch (rawType) {
    case "income":
      return "operation.types.income";
    case "vital":
      return "operation.types.vital";
    case "non_essential":
      return "operation.types.non_essential";
    case "saving":
      return "saving";
    default:
      return "operation.types.unknown";
  }
}
