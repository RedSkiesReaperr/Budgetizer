<script lang="ts" setup>
interface Props {
  isOpen: boolean;
  onCanceled: () => void;
  onConfirmed: () => void;
}

const props = defineProps<Props>();
</script>

<template>
  <v-dialog
    v-model="open"
    transition="fade-transition"
    persistent
    max-width="1000"
  >
    <v-card>
      <v-card-title class="text-h5">
        <slot name="title"></slot>
      </v-card-title>
      <v-card-subtitle class="mb-3 text-subtitle-1">
        <slot name="subtitle" class="mt-0"></slot>
      </v-card-subtitle>
      <v-card-text>
        <slot name="content"></slot>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn variant="text" @click="props.onCanceled()">
          {{ $t("actions.cancel") }}
        </v-btn>
        <v-btn color="red" variant="text" @click="props.onConfirmed()">
          {{ $t("actions.confirm") }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script lang="ts">
export default {
  computed: {
    open(): boolean {
      return this.$props.isOpen
    },
  }
}
</script>
