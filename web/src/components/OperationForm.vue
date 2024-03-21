<script setup lang="ts">
import {Operation} from "@/api/resources/operations";
import Form from "@/components/Form.vue";
import AmountInput from "@/components/AmountInput.vue";
import TypeSelector from "@/components/TypeSelector.vue";
import CategorySelector from "@/components/CategorySelector.vue";

interface Props {
  target: Operation;
  mode: OperationFormMode;
}

defineProps<Props>();
const emit = defineEmits<{
  submit: [];
  success: [];
  fail: [err: any];
  finish: [];
}>()
</script>

<template>
  <Form
    ref="form"
    :submit-request="submitRequest()"
    @submit="emit('submit')"
    @success="emit('success')"
    @fail="(err: any) => emit('fail', err)"
    @finish="emit('finish')">
    <v-row>
      <v-col cols="12" xs="12" sm="4" md="3" lg="2" xl="2" xxl="2">
        <v-text-field
          v-model="operationDate"
          :label="$t('operation.attributes.date')"
          variant="outlined"
          disabled
        ></v-text-field>
      </v-col>

      <v-col cols="12" xs="12" sm="8" md="9" lg="7" xl="7" xxl="7">
        <v-text-field
          v-model="targetOperation.attributes.label"
          :label="$t('operation.attributes.label')"
          variant="outlined"
          clearable
          required
        ></v-text-field>
      </v-col>

      <v-col cols="12" xs="12" sm="4" md="4" lg="3" xl="3" xxl="3">
        <AmountInput v-model="targetOperation.attributes.amount" disabled></AmountInput>
      </v-col>

      <v-col cols="12" xs="12" sm="4" md="4" lg="5" xl="4" xxl="4">
        <TypeSelector v-model="targetOperation.attributes.opType"></TypeSelector>
      </v-col>

      <v-col cols="12" xs="12" sm="4" md="4" lg="5" xl="4" xxl="4">
        <CategorySelector v-model="targetOperation.attributes.categoryId" :categories="categoriesStore.categories"/>
      </v-col>

      <v-col cols="12" xs="12" sm="4" md="2" lg="2" xl="4" xxl="4">
        <v-switch
          v-model="targetOperation.attributes.pointed"
          :label="$t('operation.attributes.pointed')"
          color="green"
          true-icon="mdi-check-circle-outline"
          false-icon="mdi-close-circle-outline"
          inset
        ></v-switch>
      </v-col>

      <v-col cols="12" xs="12" sm="8" md="10" lg="12" xl="12" xxl="12">
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
