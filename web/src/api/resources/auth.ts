import { ApiResponse } from "@/api/responses";
import client from "@/api/client";

export interface User {
    id: number;
    uid: string;
    email: string;
    name: string;
    nickname: string;
    provider: string;
    allowPasswordChange: boolean;
}

export interface SignOutResponse {
  success: boolean;
}

export interface ValidateSessionResponse {
  success: boolean;
  data: User;
}

export default {
  signIn: signIn,
  signOut: signOut,
  validateSession: validateSession,
};

async function signIn(email: string, password: string): Promise<User> {
    return (await client.post<ApiResponse<User>>("/auth/sign_in", { email: email, password: password})).data.data
}

async function signOut(): Promise<SignOutResponse> {
  return (await client.delete<ApiResponse<SignOutResponse>>(`/auth/sign_out`)).data.data;
}

async function validateSession(): Promise<ValidateSessionResponse> {
  return (await client.get<ApiResponse<ValidateSessionResponse>>(`/auth/validate_token`)).data.data;
}
