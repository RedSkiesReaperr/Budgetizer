export const knownCategories = [
  "to_categorize",
  "home",
  "bank",
  "shopping",
  "food",
  "subscriptions",
  "auto_transport",
  "beauty_care",
  "taxes",
];

export function getCategoryColor(rawCategory: string): string {
  switch (rawCategory) {
    case "to_categorize":
      return "#9e9e9e";
    case "home":
      return "#2980b9";
    case "bank":
      return "#d35400";
    case "shopping":
      return "#e74c3c";
    case "food":
      return "#f1c40f";
    case "subscriptions":
      return "#9b59b6";
    case "auto_transport":
      return "#1abc9c";
    case "beauty_care":
      return "#ff9ff3";
    case "taxes":
      return "#bdc3c7";
    default:
      return "#9e9e9e";
  }
}

export function getCategoryIcon(rawCategory: string): string {
  switch (rawCategory) {
    case "to_categorize":
      return "mdi-shape-plus-outline";
    case "home":
      return "mdi-home-circle-outline";
    case "bank":
      return "mdi-bank-outline";
    case "shopping":
      return "mdi-shopping-outline";
    case "food":
      return "mdi-food";
    case "subscriptions":
      return "mdi-cash-sync";
    case "auto_transport":
      return "mdi-plane-car";
    case "beauty_care":
      return "mdi-star-four-points-outline";
    case "taxes":
      return "mdi-cash-multiple";
    default:
      return "mdi-crosshairs-question";
  }
}

export function getCategoryTranslationKey(rawCategory: string): string {
  return knownCategories.includes(rawCategory)
    ? `operation.categories.${rawCategory}`
    : "operation.categories.unknown";
}
