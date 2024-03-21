<script setup lang="ts">
interface Props {
  submitRequest: () => Promise<any>;
}

defineProps<Props>();
defineEmits<{
  submit: [];
  success: [];
  fail: [err: any];
  finish: [];
}>()
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
      this.$emit('submit')
      await this.$props.submitRequest()
        .then(() => this.$emit('success'))
        .catch((err: any) => this.$emit('fail', err))
        .finally(() => this.$emit('finish'));
    },
  }
}
</script>
