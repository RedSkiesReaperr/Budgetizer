<script setup lang="ts">
import {getCategoryById} from "@/services/categories";
import CategoryChip from "@/components/CategoryChip.vue";

interface Props {
  categories: Category[]
}

const props = defineProps<Props>();
const [model] = defineModel<number | null>({required: true})
</script>

<template>
  <v-select
    v-model="model"
    small-chips
    :label="$t('operation.attributes.category')"
    :items="categoryItems"
    item-title="title"
    item-value="value"
    variant="outlined"
  >
    <template #selection="{ item }">
      <CategoryChip :category="getCategoryById(item.value, props.categories)" size="small"></CategoryChip>
    </template>
  </v-select>
</template>

<script lang="ts">
import {Category} from "@/api/resources/categories";
import {getCategoryReadableKey, getCategoryTranslationKey} from "@/services/categories";

export default {
  computed: {
    categoryItems(): Array<{ value: number; title: string }> {
      return this.$props.categories.map((cat: Category) => {
        const translationKey = getCategoryTranslationKey(cat)
        const title = (this.$te(translationKey)) ? this.$t(translationKey) : getCategoryReadableKey(cat)

        return {value: parseInt(cat.id), title: title};
      });
    }
  }
}
</script>
