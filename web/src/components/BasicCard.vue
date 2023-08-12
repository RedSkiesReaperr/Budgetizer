<script setup lang="ts">
interface Props {
  loading: boolean;
}
const props = defineProps<Props>();
</script>

<template>
  <v-card class="pa-4" rounded="lg" flat>
    <v-overlay
      class="align-center justify-center"
      :model-value="props.loading"
      :close-on-content-click="false"
      contained
      disabled
      persistent
    >
      <v-progress-circular color="primary" indeterminate></v-progress-circular>
    </v-overlay>

    <slot></slot>
  </v-card>
</template>

<script lang="ts"></script>
