<script lang="ts" setup>
interface Props {
  isOpen: boolean;
  loading: boolean;
}

const props = defineProps<Props>();
const emit = defineEmits(['cancel', 'confirm'])
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
        <v-overlay
          class="align-center justify-center"
          :model-value="props.loading"
          :close-on-content-click="false"
          contained
          disabled
          persistent
        >
          <v-progress-circular
            color="primary"
            indeterminate
          ></v-progress-circular>
        </v-overlay>

        <slot name="content"></slot>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn variant="text" @click="emit('cancel')">
          {{ $t("actions.cancel") }}
        </v-btn>
        <v-btn color="red" variant="text" @click="emit('confirm')">
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
