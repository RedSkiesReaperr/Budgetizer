<script setup lang="ts">
import {Category} from "@/api/resources/categories";

interface Props {
  category: Category;
  size: string;
}

const props = withDefaults(defineProps<Props>(), {
  size: "",
});
</script>

<template>
  <v-chip
    :prepend-icon="props.category.attributes.icon"
    :color="props.category.attributes.color"
    :size="props.size"
  >
    {{ translatedText }}
  </v-chip>
</template>

<script lang="ts">
import {getCategoryReadableKey, getCategoryTranslationKey} from "@/services/categories";

export default {
  computed: {
    translationKey(): string {
      return getCategoryTranslationKey(this.$props.category)
    },
    translatedText(): string {
      if (this.$te(this.translationKey)) {
        return this.$t(this.translationKey);
      } else {
        return getCategoryReadableKey(this.category)
      }
    },
  },
};
</script>
