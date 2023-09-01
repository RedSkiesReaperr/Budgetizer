import { Line } from "@/api/resources/lines";

export function copyLine(input: Line): Line {
  return {
    ...input,
    attributes: { ...input.attributes },
    links: { ...input.links },
  };
}
