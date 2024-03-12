import client from "@/api/client";
import {ApiResponse} from "../responses";

export interface Line {
  id: string;
  type: "lines";
  links: {
    self: string;
  };
  attributes: {
    label: string;
    amount: number;
    lineType: string;
    category: string;
  };
}

interface UpdatePayload {
  label?: string;
  amount?: number;
  lineType?: string;
  category?: string;
}

interface CreatePayload {
  label: string;
  amount: number;
  lineType: string;
}

export default {
  getAll: getAll,
  createOne: createOne,
  updateOne: updateOne,
  deleteOne: deleteOne,
};

async function getAll(): Promise<Line[]> {
  return (await client.get<ApiResponse<Line[]>>("/lines")).data.data;
}

async function updateOne(
  lineId: string,
  updatePayload: UpdatePayload
): Promise<Line> {
  return (
    await client.patch<ApiResponse<Line>>(`/lines/${lineId}`, {
      data: {
        type: "lines",
        id: lineId,
        attributes: updatePayload,
      },
    })
  ).data.data;
}

async function createOne(createPayload: CreatePayload): Promise<Line> {
  return (
    await client.post<ApiResponse<Line>>("/lines", {
      data: {
        type: "lines",
        attributes: createPayload,
      },
    })
  ).data.data;
}

async function deleteOne(lineId: string): Promise<any> {
  return await client.delete<ApiResponse<Line>>(`/lines/${lineId}`);
}
