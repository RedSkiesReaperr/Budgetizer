import client from "@/api/client";
import { ApiResponse } from "../responses";

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

export default {
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
