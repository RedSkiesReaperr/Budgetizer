import { defineStore } from "pinia";

export enum AlertType {
    Success = "success",
    Info = "info",
    Warning = "warning",
    Error = "error"
}

export const useAlertStore = defineStore("alert", {
  state: () => ({
    displayed: false,
    title: "",
    message: "",
    type: AlertType.Error,
  }),
  actions: {
    reset() {
        this.displayed = false
        this.type = AlertType.Error
        this.title = ""
        this.message = ""
    },
    async show(type: AlertType, title: string, message: string) {
        this.type = type
        this.title = title
        this.message = message
        this.displayed = true

        setTimeout(() => { this.reset() }, 3000);
    },
    async hide() {
        this.reset()
    }
  },
});
