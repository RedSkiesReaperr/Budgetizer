import { Operation } from "@/api/resources/operations";

export function copyOperation(input: Operation): Operation {
  return {
    ...input,
    attributes: { ...input.attributes },
    links: { ...input.links },
  };
}
