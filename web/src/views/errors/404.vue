<template>
  <v-container class="w-25">
    <v-card class="pa-4" rounded="lg" flat outlined border="error lg">
      <v-card-title class="text-center">
        <v-icon icon="mdi-emoticon-sad-outline" size="x-large" color="error"></v-icon>
      </v-card-title>
      <v-card-title class="mb-6 text-center">
        {{ $t("404.title") }}
      </v-card-title>
      <v-card-text class="mb-6 text-body-1 text-center">{{ $t("404.text") }}</v-card-text>
      <v-card-actions>
        <v-btn prepend-icon="mdi-keyboard-backspace" :to="{name: 'login'}" variant="text">
          {{ $t("404.button") }}
        </v-btn>

      </v-card-actions>
    </v-card>
  </v-container>
</template>

<script lang="ts">
export default {};
</script>
