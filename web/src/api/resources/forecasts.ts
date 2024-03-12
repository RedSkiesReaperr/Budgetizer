import client from "@/api/client";
import {ApiResponse} from "@/api/responses";

export interface Forecast {
  type: "forecasts",
  attributes: {
    income: number;
    vital: number;
    nonEssential: number;
    saving: number;
    vitalDiff: number;
    nonEssentialDiff: number;
    savingDiff: number;
    vitalDiffPercentage: number;
    nonEssentialDiffPercentage: number;
    savingDiffPercentage: number;
  }
}

export default {
  get: get,
}

async function get(): Promise<Forecast> {
  return (await client.get<ApiResponse<Forecast>>("/forecasts")).data.data;
}
