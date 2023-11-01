import moment from "moment";

export function daysInRangeAsStr(from: moment.Moment, to: moment.Moment, format: string): string[] {
  const days: string[] = []

  for (let i = from.clone(); i.isSameOrBefore(to); i.add(1, "days")) {
    days.push(i.format(format))
  }

  return days
}

export function daysInRangeAsMoment(from: moment.Moment, to: moment.Moment): moment.Moment[] {
  const days: moment.Moment[] = []

  for (let i = from.clone(); i.isSameOrBefore(to); i.add(1, "days")) {
    days.push(i.clone())
  }

  return days
}
