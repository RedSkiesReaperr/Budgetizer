import {ApiResponse} from "@/api/responses";
import client from "@/api/client";

export interface Category {
  id: string;
  type: "categories";
  links: {
    self: string;
  };
  attributes: {
    key: string;
    color: string;
    icon: string;
  };
}

export default {
  getAll: getAll,
  getOne: getOne,
};

async function getAll(): Promise<Category[]> {
  return (await client.get<ApiResponse<Category[]>>("/categories")).data.data;
}

async function getOne(categoryId: number): Promise<Category> {
  return (await client.get<ApiResponse<Category>>(`/categories/${categoryId}`)).data
    .data;
}
