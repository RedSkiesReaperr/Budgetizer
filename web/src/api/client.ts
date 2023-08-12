import axios from "axios";

const client = axios.create({
  baseURL: import.meta.env.VITE_API_BASE,
  timeout: 1000,
  headers: {
    "Content-Type": "application/vnd.api+json",
  },
});

export default client;
