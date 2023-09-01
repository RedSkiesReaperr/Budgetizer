import client from "@/api/client";
import { ApiResponse } from "../responses";
import { create } from "domain";

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
  relationships: {
    budget: {
      links: {
        self: string;
        related: string;
      };
    };
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
  createOne: createOne,
  updateOne: updateOne,
};

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

async function createOne(
  budgetId: string,
  createPayload: CreatePayload
): Promise<Line> {
  return (
    await client.post<ApiResponse<Line>>("/lines", {
      data: {
        type: "lines",
        attributes: createPayload,
        relationships: {
          budget: {
            data: {
              type: "budgets",
              id: budgetId,
            },
          },
        },
      },
    })
  ).data.data;
}
