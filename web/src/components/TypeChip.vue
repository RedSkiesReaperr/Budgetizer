<script setup lang="ts">
import {
  getTypeIcon,
  getTypeColor,
  getTypeTranslationKey,
} from "@/services/types";

interface Props {
  rawType: string;
  size: string;
}

const props = withDefaults(defineProps<Props>(), {
  size: "",
});
</script>

<template>
  <v-chip
    :prepend-icon="getTypeIcon(props.rawType)"
    :color="getTypeColor(props.rawType)"
    :size="props.size"
  >
    {{ translatedText }}
  </v-chip>
</template>

<script lang="ts">
export default {
  computed: {
    translatedText(): string {
      return this.$t(getTypeTranslationKey(this.$props.rawType));
    },
  },
};
</script>
