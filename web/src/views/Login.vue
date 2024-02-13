<template>
  <v-container>
    <div class="mb-6" :style="{ textAlign: 'center' }">
      <h1>Budgetizer</h1>
    </div>
    <LanguageSwitch id="login-language-switch"></LanguageSwitch>
  </v-container>
  <v-container class="w-25">
    <BasicCard :loading="isLoggingIn">
      <v-form @submit.prevent="login">
        <v-text-field v-model="email" type="email" :label="$t('email')" variant="outlined" autocomplete="username"></v-text-field>
        <v-text-field v-model="password" type="password" :label="$t('password')" variant="outlined" autocomplete="current-password"></v-text-field>
        <v-btn type="submit" prepend-icon="mdi-login" variant="tonal" color="#27ae60" block>{{
          $t('actions.login')
        }}</v-btn>
      </v-form>
    </BasicCard>
  </v-container>

  <Alert></Alert>
</template>

<style>
#login-language-switch {
  position: absolute;
  top: 1rem;
  right: 1rem;
}
</style>
<script lang="ts">
import api from '@/api';
import BasicCard from '@/components/BasicCard.vue';
import Alert from "@/components/Alert.vue";
import { AlertType, useAlertStore } from '@/stores/alert';
import { AxiosError } from 'axios';
import LanguageSwitch from "@/components/LanguageSwitch.vue";

export default {
  setup() {
    const alertStore = useAlertStore()

    return { alertStore }
  },
  data() {
    return {
      email: '',
      password: '',
      isLoggingIn: false,
    };
  },
  beforeCreate() {
    api.auth.validateSession()
      .then(() => {
        this.$router.push({name: 'dashboardOverview'});
      }).catch(() => { });
  },
  methods: {
    login() {
      this.alertStore.hide()
      this.isLoggingIn = true

      api.auth.signIn(this.email, this.password)
        .then(() => {
          this.$router.push({name: 'budgetSelector'});
          this.alertStore.hide()
        })
        .catch((err: AxiosError<{ errors: string[], success: boolean }>) => {
          const errors = err.response?.data.errors.join('. ') || this.$t("something_went_wrong")

          this.alertStore.show(AlertType.Error, this.$t("login.error_title"), errors)
        })
        .finally(() => {
          this.isLoggingIn = false
        })
    }
  },
  components: {LanguageSwitch, BasicCard, Alert }
};
</script>
