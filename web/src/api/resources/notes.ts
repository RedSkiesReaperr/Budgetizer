import client from "@/api/client";
import {ApiResponse} from "../responses";

export interface Note {
  id: string;
  type: "notes";
  links: {
    self: string;
  };
  attributes: {
    title: string;
    description: string;
    month: number;
    year: number;
  };
}

interface UpdatePayload {
  title?: string;
  description?: string;
}

interface CreatePayload {
  title: string;
  description: string;
  month: number;
  year: number;
}

export default {
  getAll: getAll,
  getOne: getOne,
  createOne: createOne,
  updateOne: updateOne,
  deleteOne: deleteOne,
};

async function getAll(month: number, year: number): Promise<Note[]> {
  return (await client.get<ApiResponse<Note[]>>(`/notes?filter[month]=${month}&filter[year]=${year}`)).data.data;
}

async function getOne(noteId: number): Promise<Note> {
  return (await client.get<ApiResponse<Note>>(`/notes/${noteId}`)).data
    .data;
}

async function updateOne(noteId: string, updatePayload: UpdatePayload): Promise<Note> {
  return (
    await client.patch<ApiResponse<Note>>(`/notes/${noteId}`, {
      data: {
        type: "notes",
        id: noteId,
        attributes: updatePayload,
      },
    })
  ).data.data;
}

async function createOne(createPayload: CreatePayload): Promise<Note> {
  return (
    await client.post<ApiResponse<Note>>("/notes", {
      data: {
        type: "notes",
        attributes: createPayload,
      },
    })
  ).data.data;
}

async function deleteOne(noteId: string): Promise<any> {
  return await client.delete<ApiResponse<Note>>(`/notes/${noteId}`);
}
