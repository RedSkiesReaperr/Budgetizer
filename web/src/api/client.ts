import i18n from "@/plugins/vue-i18n";
import axios from "axios";

const client = axios.create({
  baseURL: import.meta.env.VITE_API_BASE,
  timeout: 1000,
  withCredentials: true,
  headers: {
    "Content-Type": "application/vnd.api+json",
    "locale": i18n.global.locale.value
  },
});

export default client;
