<template>
  <v-row justify="center">
    <v-col align-self="center" id="login-error" cols="12" xs="12" sm="10" md="8" lg="6" xl="4" xxl="4">
      <v-slide-y-reverse-transition>
        <div v-if="alertStore.displayed">
          <v-alert :closable="true" location="bottom" :title="alertStore.title" :type="alertStore.type">
            {{ alertStore.message }}
          </v-alert>
        </div>
      </v-slide-y-reverse-transition>
    </v-col>
  </v-row>
</template>


<style>
#login-error {
  position: fixed;
  bottom: 0;
}
</style>

<script lang="ts">
import {useAlertStore} from '@/stores/alert';


export default {
  setup() {
    const alertStore = useAlertStore()

    return {alertStore}
  }
}
</script>
