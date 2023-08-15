<script setup lang="ts">
import BasicCard from "./BasicCard.vue";

interface Props {
  loading: boolean;
}

defineProps<Props>();
</script>

<template>
  <BasicCard :loading="loading">
    <v-btn
      class=""
      icon="mdi-information-variant-circle-outline"
      size="small"
      variant="text"
      :style="{ position: 'absolute', top: 0, right: 0, zIndex: 2 }"
      @click="infoOpen = !infoOpen"
    >
    </v-btn>

    <slot name="main"></slot>

    <v-expand-transition>
      <v-card
        v-if="infoOpen"
        :style="{
          bottom: 0,
          left: 0,
          right: 0,
          height: '100%',
          width: '100%',
          opacity: 0.9,
          position: 'absolute',
        }"
        elevation="10"
      >
        <v-card-text class="p-0">
          <div class="text-h6 mb-4">{{ $t('information', 2) }}</div>
          <slot name="info"></slot>
        </v-card-text>
        <v-card-actions> </v-card-actions>
      </v-card>
    </v-expand-transition>
  </BasicCard>
</template>

<script lang="ts">
export default {
  data() {
    return {
      infoOpen: false,
    };
  },
};
</script>
