<script setup lang="ts">
import {
  getCategoryIcon,
  getCategoryColor,
  getCategoryTranslationKey,
} from "@/services/categories";

interface Props {
  rawCategory: string;
  size: string;
}

const props = withDefaults(defineProps<Props>(), {
  size: "",
});
</script>

<template>
  <v-chip
    :prepend-icon="getCategoryIcon(props.rawCategory)"
    :color="getCategoryColor(props.rawCategory)"
    :size="props.size"
  >
    {{ translatedText }}
  </v-chip>
</template>

<script lang="ts">
export default {
  computed: {
    translatedText(): string {
      return this.$t(getCategoryTranslationKey(this.$props.rawCategory));
    },
  },
};
</script>
