import customFr from "@/i18n/fr";
import customEn from "@/i18n/en";
import { fr, en } from "vuetify/locale";

export default {
  fr: { ...customFr, $vuetify: fr },
  en: { ...customEn, $vuetify: en },
};
