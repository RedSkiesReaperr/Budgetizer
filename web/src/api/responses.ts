export interface ApiResponse<T> {
  data: T
}

export interface ApiError {
  errors: Array<{
    title: string,
    detail: string,
    code: string,
    status: string
  }>
}
