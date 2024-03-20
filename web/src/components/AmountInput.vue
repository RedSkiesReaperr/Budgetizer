<script setup lang="ts">
const [model] = defineModel<number>({
  required: true,
  get(v: string | number): number {
    if (typeof v === "string") {
      return 0
    }

    return v
  },
  set(v: string | number): number {
    if (typeof v === "string") {
      return 0
    }

    return v
  }
})
</script>

<template>
  <v-text-field
    v-model.number="model"
    :label="$t('operation.attributes.amount')"
    :rules="rules"
    variant="outlined"
    type="number"
    prefix="€"
  ></v-text-field>
</template>

<script lang="ts">
export default {
  data() {
    return {
      rules: [
        (value: number) => {
          return (value && value > 0) ? true : this.$t("form_validations.gt", {limit: 0})
        }
      ]
    }
  },
}
</script>
