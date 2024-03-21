<script setup lang="ts">
import BasicCard from "@/components/BasicCard.vue";

interface Props {
  loading: boolean
}

const props = withDefaults(defineProps<Props>(), {loading: false})
const emit = defineEmits(['edit', 'delete'])
</script>

<template>
  <BasicCard :loading="props.loading">
    <v-btn
      icon="mdi-pencil-circle"
      variant="text"
      color="blue"
      @click="emit('edit')"
      :style="{ position: 'absolute', top: 0, left: 0}">
    </v-btn>
    <v-btn
      icon="mdi-delete-circle"
      variant="text"
      color="red"
      @click="emit('delete')"
      :style="{ position: 'absolute', top: 0, right: 0}">
    </v-btn>
    <slot></slot>
  </BasicCard>
</template>

<script lang="ts">
export default {}
</script>
