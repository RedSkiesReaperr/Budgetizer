import client from "@/api/client";
import { ApiResponse } from "../responses";
import moment from "moment";

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

export interface ImportResponse {
  success: boolean
}

export default {
  getAll: getAll,
  getOne: getOne,
  updateOne: updateOne,
  importFile: importFile,
};

async function getAll(
  startAt: moment.Moment,
  endAt: moment.Moment
): Promise<Operation[]> {
  return (
    await client.get<ApiResponse<Operation[]>>(
      `/operations?filter[start_at]=${startAt.format()}&filter[end_at]=${endAt.format()}`
    )
  ).data.data;
}

async function getOne(operationId: string): Promise<Operation> {
  return (
    await client.get<ApiResponse<Operation>>(`/operations/${operationId}`)
  ).data.data;
}

async function updateOne(
  operationId: string,
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

async function importFile(file: File): Promise<ImportResponse> {
  const formData = new FormData()
  formData.append("file", file)

  return (
    await client.post<ApiResponse<ImportResponse>>(`/operations`, formData, {
      headers: {
        "Content-Type": "multipart/form-data"
      }
    })
  ).data.data;
}
