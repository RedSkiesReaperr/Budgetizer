import {Category} from "@/api/resources/categories";

export const MISSING_CATEGORY_IDENTIFIER = "MISSING"
export const UNKOWN_CATEGORY_IDENTIFIER = "UNKNOWN"

export const MISSING_CATEGORY: Category = {
  id: MISSING_CATEGORY_IDENTIFIER,
  type: "categories",
  links: {
    self: "missing"
  },
  attributes: {
    key: "to_categorize",
    color: "#9e9e9e",
    icon: "mdi-crosshairs-question"
  }
}

export const UNKNOWN_CATEGORY: Category = {
  id: UNKOWN_CATEGORY_IDENTIFIER,
  type: "categories",
  links: {
    self: "unknown"
  },
  attributes: {
    key: "unknown",
    color: "#9e9e9e",
    icon: "mdi-crosshairs-question"
  }
}

export function getCategoryById(categoryId: number | string | null, categories: Category[]): Category {
  if (categoryId === null) {
    return MISSING_CATEGORY
  }

  const id: string = (typeof categoryId === "number") ? categoryId.toString() : categoryId

  return categories.find((c: Category) => id === c.id) || UNKNOWN_CATEGORY
}

export function getCategoryTranslationKey(category: Category): string {
  return `operation.categories.${category.attributes.key}`
}

export function getCategoryReadableKey(category: Category): string {
  const result = category.attributes.key.replace(/([-_\s])/g, ' ');

  return result.charAt(0).toUpperCase() + result.slice(1);
}
