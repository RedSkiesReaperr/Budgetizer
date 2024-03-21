<script setup lang="ts">
interface Props {
  submitRequest: () => Promise<any>;
  onSubmitting: () => void;
  onSubmitSuccess: () => void;
  onSubmitFailed: (err: any) => void;
  onSubmitted: () => void;
}

defineProps<Props>();
</script>

<template>
  <v-form ref="form" @submit.prevent="submit">
    <slot></slot>
    <v-btn class="d-none" type="submit"></v-btn>
  </v-form>
</template>

<script lang="ts">
export default {
  methods: {
    async submit() {
      this.$props.onSubmitting()
      await this.$props.submitRequest()
        .then(() => this.$props.onSubmitSuccess())
        .catch((err: any) => this.$props.onSubmitFailed(err))
        .finally(() => this.$props.onSubmitted());
    },
  }
}
</script>
