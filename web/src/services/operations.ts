import {Operation} from "@/api/resources/operations";
import moment from "moment/moment";

export function copyOperation(input: Operation): Operation {
  return {
    ...input,
    attributes: {...input.attributes},
    links: {...input.links},
  };
}

export function operationsForCategories(operations: Operation[], categories: string[]): Operation[] {
  return operations.filter((op: Operation) => categories.includes(op.attributes.category))
}

export function operationsForDay(operations: Operation[], targetDay: moment.Moment): Operation[] {
  const formattedTargetDay = targetDay.format("YYYY-MM-DD")

  return operations.filter((op: Operation) => moment(op.attributes.date).format("YYYY-MM-DD") === formattedTargetDay)
}
