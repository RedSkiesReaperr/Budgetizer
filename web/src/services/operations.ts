import {Operation} from "@/api/resources/operations";
import moment from "moment/moment";
import {Category} from "@/api/resources/categories";

export function copyOperation(input: Operation): Operation {
  return {
    ...input,
    attributes: {...input.attributes},
    links: {...input.links},
  };
}

export function getOperationsByCategory(category: Category, operations: Operation[]): Operation[] {
  return operations.filter((op: Operation) => op.attributes.categoryId === parseInt(category.id))
}

export function getOperationsUncategorized(operations: Operation[]): Operation[] {
  return operations.filter((op: Operation) => op.attributes.categoryId === null)
}

export function getOperationsByDay(targetDay: moment.Moment, operations: Operation[]): Operation[] {
  const formattedTargetDay: string = targetDay.format("YYYY-MM-DD")

  return operations.filter((op: Operation) => moment(op.attributes.date).format("YYYY-MM-DD") === formattedTargetDay)
}
