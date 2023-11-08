import i18n from "@/plugins/vue-i18n";
import axios from "axios";

const client = axios.create({
  baseURL: import.meta.env.VITE_API_BASE,
  timeout: 1000,
  withCredentials: true,
  headers: {
    "Content-Type": "application/vnd.api+json",
  },
});

client.interceptors.request.use(function (config) {
  config.headers["Locale"] = i18n.global.locale.value

  return config;
});

export default client;
