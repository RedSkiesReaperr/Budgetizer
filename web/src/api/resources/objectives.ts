import client from "@/api/client";
import {ApiResponse} from "@/api/responses";

export interface Objective {
  id: string;
  type: "objectives";
  links: {
    self: string;
  };
  attributes: {
    vital: number;
    nonEssential: number;
    saving: number;
  };
}

export default {
  getAll: getAll,
};

async function getAll(): Promise<Objective[]> {
  return (await client.get<ApiResponse<Objective[]>>("/objectives")).data.data;
}
