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

export interface CreatePayload {
  key: string;
  color: string;
  icon: string;
}

export interface UpdatePayload {
  key?: string;
  color?: string;
  icon?: string;
}


export default {
  getAll: getAll,
  getOne: getOne,
  createOne: createOne,
  updateOne: updateOne,
  deleteOne: deleteOne,
};

async function getAll(): Promise<Category[]> {
  return (await client.get<ApiResponse<Category[]>>("/categories")).data.data;
}

async function getOne(categoryId: number): Promise<Category> {
  return (await client.get<ApiResponse<Category>>(`/categories/${categoryId}`)).data
    .data;
}

async function createOne(createPayload: CreatePayload): Promise<Category> {
  return (
    await client.post<ApiResponse<Category>>("/categories", {
      data: {
        type: "categories",
        attributes: createPayload,
      },
    })
  ).data.data;
}

async function updateOne(categoryId: string, updatePayload: UpdatePayload): Promise<Category> {
  return (
    await client.patch<ApiResponse<Category>>(`/categories/${categoryId}`, {
      data: {
        type: "categories",
        id: categoryId,
        attributes: updatePayload,
      },
    })
  ).data.data;
}

async function deleteOne(category: Category): Promise<any> {
  return await client.delete<ApiResponse<Category>>(`/categories/${category.id}`);
}
