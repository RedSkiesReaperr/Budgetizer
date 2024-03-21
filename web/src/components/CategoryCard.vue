<script setup lang="ts">
import {Category} from "@/api/resources/categories";
import CategoryChip from "@/components/CategoryChip.vue";
import ActionCard from "@/components/ActionCard.vue";

interface Props {
  category: Category;
  onDelete: (cat: Category) => void;
  onEdit: (cat: Category) => void;
}

const props = defineProps<Props>();
</script>

<template>
  <ActionCard @edit="onEdit(category)" @delete="onDelete(category)">
    <v-card-title class="text-subtitle-1 text-center mb-2">{{ title }}</v-card-title>

    <v-card-text class="pb-0 d-flex flex-row flex-wrap justify-start align-start align-content-start">
      <div class="pb-2 w-100 d-flex flex-row flex-wrap justify-start align-start align-content-start">
        <div class="w-50 d-flex flex-column flex-wrap justify-start align-start align-content-center">
          <div class="text-body-2">{{ $t("color") }}</div>
        </div>
        <div class="w-50 d-flex flex-column flex-wrap justify-start align-start align-content-center">
          <div>
            <v-btn class="d-flex" size="x-small" :color="props.category.attributes.color"></v-btn>
          </div>
        </div>
      </div>
      <div class="pb-2 w-100 d-flex flex-row flex-wrap justify-start align-start align-content-start">
        <div class="w-50 d-flex flex-column flex-wrap justify-start align-start align-content-center">
          <div class="text-body-2">{{ $t("icon") }}</div>
        </div>
        <div class="w-50 d-flex flex-column flex-wrap justify-start align-start align-content-center">
          <v-btn class="d-flex" size="" variant="text" :append-icon="props.category.attributes.icon"></v-btn>
        </div>
      </div>
      <v-divider class="mt-1"></v-divider>
      <div class="mt-3 d-flex flex-grow-1 flex-row flex-wrap justify-center align-start align-content-stretch">
        <CategoryChip :category="props.category" size="default"></CategoryChip>
      </div>
    </v-card-text>
  </ActionCard>
</template>

<script lang="ts">
import {getCategoryReadableKey, getCategoryTranslationKey} from "@/services/categories";

export default {
  computed: {
    translationKey(): string {
      return getCategoryTranslationKey(this.$props.category)
    },
    title(): string {
      if (this.$te(this.translationKey)) {
        return this.$t(this.translationKey);
      } else {
        return getCategoryReadableKey(this.category)
      }
    }
  }
}
</script>
