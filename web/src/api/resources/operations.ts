import client from "@/api/client";
import { ApiResponse } from "../responses";

export interface Operation {
  id: string;
  type: string;
  links: {
    self: string;
  };
  attributes: {
    date: string;
    label: string;
    amount: number;
    comment: string;
    pointed: boolean;
    opType: string;
    category: string;
  };
}

interface UpdatePayload {
  label?: string;
  amount?: number;
  comment?: string;
  pointed?: boolean;
  opType?: string;
  category?: string;
}

export default {
  getAll: getAll,
  getOne: getOne,
  updateOne: updateOne,
};

async function getAll(): Promise<Operation[]> {
  return (await client.get<ApiResponse<Operation[]>>("/operations")).data.data;
}

async function getOne(operationId: number): Promise<Operation> {
  return (
    await client.get<ApiResponse<Operation>>(`/operations/${operationId}`)
  ).data.data;
}

async function updateOne(
  operationId: number,
  updatePayload: UpdatePayload
): Promise<Operation> {
  return (
    await client.patch<ApiResponse<Operation>>(`/operations/${operationId}`, {
      data: {
        type: "operations",
        id: operationId,
        attributes: updatePayload,
      },
    })
  ).data.data;
}
