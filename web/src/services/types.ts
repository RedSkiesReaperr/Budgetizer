export function getTypeColor(rawType: string): string {
  switch (rawType) {
    case "income":
      return "green";
    case "vital":
      return "#9b59b6";
    case "non_essential":
      return "#3498db";
    default:
      return "grey";
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
    default:
      return "operation.types.unknown";
  }
}
