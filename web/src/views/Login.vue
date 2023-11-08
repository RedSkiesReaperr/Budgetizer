<template>
  <v-container>
    <div class="mb-6" :style="{ textAlign: 'center' }">
      <h1>Budgetizer</h1>
    </div>
  </v-container>

  <v-container class="w-25">
    <BasicCard :loading="isLoggingIn">
      <v-text-field v-model="email" type="email" :label="$t('email')" variant="outlined"></v-text-field>
      <v-text-field v-model="password" type="password" :label="$t('password')" variant="outlined"></v-text-field>
      <v-btn block @click="login" prepend-icon="mdi-login" variant="tonal" color="#27ae60">{{ $t('actions.login') }}</v-btn>
    </BasicCard>
  </v-container>

  <v-container id="login-error" class="w-50">
    <v-alert v-model="hasErrors" icon="mdi-alert-circle-outline" location="bottom" :title="$t('login.error_title')" type="error">
      <li v-for="(err, index) in errors" v-bind:key="index">
        {{ err }}
      </li>
    </v-alert>
  </v-container>
</template>

<style>
#login-error {
  position: absolute;
  bottom: 0;
  left: 25%;
}
</style>

<script lang="ts">
import api from '@/api';
import BasicCard from '@/components/BasicCard.vue';
import routes from "@/router/routes";

export default {
  data() {
    return {
      email: '',
      password: '',
      isLoggingIn: false,
      errors: [] as String[],
    };
  },
  beforeCreate() {
    api.auth.validateSession()
      .then(() => {
        this.$router.push(routes.budget.overview);
      }).catch(() => { });
  },
  computed: {
    hasErrors() {
      return this.errors.length > 0
    }
  },
  methods: {
    login() {
      this.isLoggingIn = true
      api.auth.signIn(this.email, this.password)
        .then(() => {
          this.$router.push(routes.selector);
        })
        .catch((err) => {
          this.errors = err.response.data.errors
        })
        .finally(() => {
          this.isLoggingIn = false
        })
    }
  },
  components: { BasicCard }
};
</script>
  