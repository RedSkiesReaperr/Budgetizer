<template>
  <v-container id="login-error" class="w-50">
    <v-slide-y-reverse-transition>
      <div v-if="alertStore.displayed">
        <v-alert :closable="true" location="bottom" :title="alertStore.title" :type="alertStore.type">
          {{ alertStore.message }}
        </v-alert>
      </div>
    </v-slide-y-reverse-transition>
  </v-container>
</template>


<style>
#login-error {
  position: fixed;
  bottom: 0;
  left: 25%;
}
</style>

<script lang="ts">
import { useAlertStore } from '@/stores/alert';


export default {
  setup() {
    const alertStore = useAlertStore()

    return { alertStore }
  }
}
</script>