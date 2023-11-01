import {Line} from "@/api/resources/lines";

export function copyLine(input: Line): Line {
  return {
    ...input,
    attributes: {...input.attributes},
    links: {...input.links},
  };
}

export function linesForTypes(lines: Line[], types: string[]): Line[] {
  return lines.filter((l) => types.includes(l.attributes.lineType))
}
