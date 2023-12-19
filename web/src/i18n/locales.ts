import customFr from "@/i18n/fr";
import customEn from "@/i18n/en";
import { fr, en } from "vuetify/locale";

export default {
  fr: { $vuetify: fr, ...customFr },
  en: { $vuetify: en, ...customEn },
};
