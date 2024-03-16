<script setup lang="ts">
import {Operation} from "@/api/resources/operations";
import {getCategoryById} from "@/services/categories";
import {formatNumber} from "@/services/formatters";
import Form from "@/components/Form.vue";

interface Props {
  target: Operation;
  mode: OperationFormMode;
  onSubmitting: () => void;
  onSubmitSuccess: () => void;
  onSubmitFailed: () => void;
  onSubmitted: () => void;
}

const props = defineProps<Props>();
</script>

<template>
  <Form
    ref="form"
    :submit-request="submitRequest()"
    :on-submitting="props.onSubmitting"
    :on-submit-success="props.onSubmitSuccess"
    :on-submit-failed="props.onSubmitFailed"
    :on-submitted="props.onSubmitted">
    <v-row>
      <v-col cols="12" sm="6" md="3">
        <v-text-field
          v-model="operationDate"
          :label="$t('operation.attributes.date')"
          variant="outlined"
          disabled
        ></v-text-field>
      </v-col>

      <v-col cols="12" sm="6" md="6">
        <v-text-field
          v-model="targetOperation.attributes.label"
          :label="$t('operation.attributes.label')"
          variant="outlined"
          clearable
          required
        ></v-text-field>
      </v-col>
      <v-col cols="12" md="3">
        <v-text-field
          :model-value="formatNumber(targetOperation.attributes.amount)"
          :label="$t('operation.attributes.amount')"
          variant="outlined"
          disabled
        ></v-text-field>
      </v-col>

      <v-col cols="12" sm="6" md="4">
        <v-select
          v-model="targetOperation.attributes.opType"
          small-chips
          default="editingOperation.attributes.opType"
          :label="$t('operation.attributes.type')"
          :items="typeItems"
          item-title="title"
          item-value="value"
          variant="outlined"
        >
          <template #selection="{ item }">
            <TypeChip :raw-type="item.value" size="small"></TypeChip>
          </template>
        </v-select>
      </v-col>
      <v-col cols="12" sm="6" md="4">
        <v-select
          v-model="targetOperation.attributes.categoryId"
          small-chips
          :label="$t('operation.attributes.category')"
          :items="categoryItems"
          item-title="title"
          item-value="value"
          variant="outlined"
        >
          <template #selection="{ item }">
            <CategoryChip
              :category="getCategoryById(item.value, categories)"
              size="small"
            ></CategoryChip>
          </template>
        </v-select>
      </v-col>
      <v-col cols="12" md="2">
        <v-switch
          v-model="targetOperation.attributes.pointed"
          :label="$t('operation.attributes.pointed')"
          color="green"
          true-icon="mdi-check-circle-outline"
          false-icon="mdi-close-circle-outline"
          inset
        ></v-switch>
      </v-col>
      <v-col cols="12" md="12">
        <v-text-field
          v-model="targetOperation.attributes.comment"
          :label="$t('operation.attributes.comment')"
          required
          variant="outlined"
          clearable
        ></v-text-field>
      </v-col>
    </v-row>
  </Form>
</template>

<script lang="ts">

import api from "@/api";
import {getCategoryReadableKey, getCategoryTranslationKey} from "@/services/categories";
import {useCategoriesStore} from "@/stores/categories";
import {Category} from "@/api/resources/categories";
import TypeChip from "@/components/TypeChip.vue";
import CategoryChip from "@/components/CategoryChip.vue";
import {UpdatePayload} from "@/api/resources/operations";

export enum OperationFormMode {EDIT}

const categoriesStore = useCategoriesStore()

export default {
  data() {
    return {
      targetOperation: this.$props.target,
      typeItems: [
        {value: "income", title: this.$t("operation.types.income")},
        {value: "vital", title: this.$t("operation.types.vital")},
        {
          value: "non_essential",
          title: this.$t("operation.types.non_essential"),
        },
      ]
    }
  },
  computed: {
    categories(): Category[] {
      return categoriesStore.categories;
    },
    operationDate(): string {
      return new Date(this.targetOperation.attributes.date).toLocaleDateString(this.$i18n.locale);
    },
    categoryItems(): Array<{ value: string; title: string }> {
      let items: Array<{ value: string; title: string }> = [];

      categoriesStore.categories.forEach((cat: Category) => {
        const translationKey = getCategoryTranslationKey(cat)
        const title = (this.$te(translationKey)) ? this.$t(translationKey) : getCategoryReadableKey(cat)

        items.push({value: cat.id, title: title});
      });

      return items;
    },
    updatePayload(): UpdatePayload {
      return {
        label: this.targetOperation.attributes.label,
        pointed: this.targetOperation.attributes.pointed,
        comment: this.targetOperation.attributes.comment,
        opType: this.targetOperation.attributes.opType,
        categoryId: this.targetOperation.attributes.categoryId
      }
    }
  },
  methods: {
    submitRequest(): () => Promise<any> {
      switch (this.$props.mode) {
        case OperationFormMode.EDIT:
          return () => api.operations.updateOne(this.targetOperation.id, this.updatePayload)
        default:
          return () => new Promise<any>((_, reject) => reject())
      }
    },
  },
  components: {TypeChip, CategoryChip}
}
</script>
