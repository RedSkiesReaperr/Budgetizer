<script lang="ts" setup>
import Form from "@/components/Form.vue";
</script>


<template>
  <v-container>
    <div class="mb-6" :style="{ textAlign: 'center' }">
      <h1>Budgetizer</h1>
    </div>
    <LanguageSwitch id="login-language-switch"></LanguageSwitch>
  </v-container>
  <v-container class="w-25">
    <BasicCard :loading="isLoggingIn">
      <Form
        ref="loginForm"
        :submit-request="loginRequest()"
        @submit="loginSubmitting"
        @success="loginSucceed"
        @fail="(err: LoginError) => loginFailed(err)"
        @finish="loginSubmitted">
        <v-text-field v-model="email" type="email" :label="$t('email')" variant="outlined"
                      autocomplete="username"/>
        <v-text-field v-model="password" type="password" :label="$t('password')" variant="outlined"
                      autocomplete="current-password"/>
        <v-btn type="submit" prepend-icon="mdi-login" variant="tonal" color="#27ae60" :disabled="!loginAvailable"
               @click="submitLogin" block>
          {{ $t('actions.login') }}
        </v-btn>
      </Form>
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
import {AlertType, useAlertStore} from '@/stores/alert';
import {AxiosError} from 'axios';
import LanguageSwitch from "@/components/LanguageSwitch.vue";

const alertStore = useAlertStore()

type LoginError = AxiosError<{ errors: string[], success: boolean }>

export default {
  data() {
    return {
      email: '',
      password: '',
      isLoggingIn: false,
    };
  },
  beforeCreate() {
    api.auth.validateSession()
      .then(() => this.$router.push({name: 'dashboardOverview'}))
      .catch(() => {
      });
  },
  computed: {
    loginAvailable(): boolean {
      return (this.email != '' && this.password != '' && !this.isLoggingIn)
    }
  },
  methods: {
    loginRequest(): () => Promise<any> {
      return () => api.auth.signIn(this.email, this.password)
    },
    submitLogin() {
      alertStore.hide()
    },
    loginSubmitting() {
      this.isLoggingIn = true
    },
    loginSucceed() {
      this.$router.push({name: 'dashboardOverview'});
      alertStore.hide()
    },
    loginFailed(err: LoginError) {
      const errors = err.response?.data.errors.join('. ') || this.$t("something_went_wrong")
      alertStore.show(AlertType.Error, this.$t("login.error_title"), errors)
    },
    loginSubmitted() {
      this.isLoggingIn = false
    },
  },
  components: {LanguageSwitch, BasicCard, Alert}
};
</script>
