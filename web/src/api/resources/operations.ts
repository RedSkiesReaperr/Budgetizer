import client from "@/api/client";
import {ApiError, ApiResponse} from "@/api/responses";

export interface Operation {
  id: string,
  type: string,
  links: {
    self: string
  },
  attributes: {
    date: string,
    label: string,
    amount: number,
    comment: string,
    pointed: boolean,
    opType: string,
    category: string
  }
}

export const Operations = {
  getAll: async (): Promise<ApiResponse<Array<Operation>>> => {
    const {data} = await client.get<ApiResponse<Array<Operation>>>('/operations')
    return data
  },
  getOne: async (operationId: number): Promise<ApiResponse<Operation>> => {
    const {data} = await client.get<ApiResponse<Operation>>(`/operations/${operationId}`)
    return data
  },
  updateOne: async (operationId: number, updatePayload: {
    label?: string,
    amount?: number,
    comment?: string,
    pointed?: boolean,
    opType?: string,
    category?: string
  }): Promise<ApiResponse<Operation>> => {
    const response = await client.patch<ApiResponse<Operation>>(`/operations/${operationId}`, {
      data: {
        type: 'operations',
        id: operationId,
        attributes: updatePayload
      }
    })
    return response.data
  }
}
