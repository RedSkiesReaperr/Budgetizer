<script setup lang="ts">
import TypeChip from "@/components/TypeChip.vue";
import {getTypeTranslationKey} from "@/services/types";

const [model] = defineModel<string | undefined>({required: true})
</script>

<template>
  <v-select
    v-model.lazy="model"
    :label="$t('operation.attributes.type')"
    :items="typesList"
    :rules="rules"
    item-value="value"
    variant="outlined"
    small-chips
    required
  >
    <template v-slot:item="{ props, item }">
      <v-list-item v-bind="props" :title="$t(getTypeTranslationKey(item.value))"></v-list-item>
    </template>
    <template #selection="{ item }">
      <TypeChip
        :raw-type="item.value"
        size="small"
      ></TypeChip>
    </template>
  </v-select>
</template>

<script lang="ts">
export default {
  data() {
    return {
      typesList: ["income", "vital", "non_essential"],
      rules: [
        (value: string) =>
          value ? true : this.$t("form_validations.required")
      ]
    }
  }
}
</script>
