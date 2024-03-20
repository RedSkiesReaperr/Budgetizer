<script setup lang="ts">
import {Operation} from "@/api/resources/operations";
import Form from "@/components/Form.vue";
import AmountInput from "@/components/AmountInput.vue";
import TypeSelector from "@/components/TypeSelector.vue";
import CategorySelector from "@/components/CategorySelector.vue";

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
        <AmountInput v-model="targetOperation.attributes.amount" disabled></AmountInput>
      </v-col>

      <v-col cols="12" sm="6" md="4">
        <TypeSelector v-model="targetOperation.attributes.opType"></TypeSelector>
      </v-col>
      <v-col cols="12" sm="6" md="4">
        <CategorySelector v-model="targetOperation.attributes.categoryId" :categories="categoriesStore.categories"/>
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
import {useCategoriesStore} from "@/stores/categories";
import {UpdatePayload} from "@/api/resources/operations";

export enum OperationFormMode {EDIT}

const categoriesStore = useCategoriesStore()

export default {
  data() {
    return {
      targetOperation: this.$props.target,
    }
  },
  computed: {
    operationDate(): string {
      return new Date(this.targetOperation.attributes.date).toLocaleDateString(this.$i18n.locale);
    },
    updatePayload(): UpdatePayload {
      return {
        label: this.targetOperation.attributes.label,
        pointed: this.targetOperation.attributes.pointed,
        comment: this.targetOperation.attributes.comment,
        opType: this.targetOperation.attributes.opType,
        categoryId: this.targetOperation.attributes.categoryId || undefined
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
}
</script>
