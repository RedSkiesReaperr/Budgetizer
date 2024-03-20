<script setup lang="ts">
import {Line} from "@/api/resources/lines";
import Form from "@/components/Form.vue";
import AmountInput from "@/components/AmountInput.vue";
import TypeSelector from "@/components/TypeSelector.vue";

interface Props {
  target: Line;
  mode: LineFormMode;
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
      <v-col cols="12" xs="12" sm="12" md="6" lg="5" xl="5" xxl="5">
        <v-text-field
          v-model="targetLine.attributes.label"
          :label="$t('operation.attributes.label')"
          :rules="rules.label"
          variant="outlined"
          clearable
          required
        ></v-text-field>
      </v-col>
      <v-col cols="12" xs="12" sm="12" md="6" lg="4" xl="4" xxl="4">
        <AmountInput v-model="targetLine.attributes.amount"></AmountInput>
      </v-col>
      <v-col cols="12" xs="12" sm="12" md="12" lg="3" xl="3" xxl="3">
        <TypeSelector v-model="targetLine.attributes.lineType"></TypeSelector>
      </v-col>
    </v-row>
  </Form>
</template>

<script lang="ts">
import api from "@/api";
import {UpdatePayload, CreatePayload} from "@/api/resources/lines";

export enum LineFormMode {EDIT, CREATE}

export default {
  data() {
    return {
      targetLine: this.$props.target,
      rules: {
        label: [
          (value: string) =>
            value ? true : this.$t("form_validations.required"),
        ],
      }
    }
  },
  computed: {
    updatePayload(): UpdatePayload {
      return {
        label: this.targetLine.attributes.label,
        amount: this.targetLine.attributes.amount,
        lineType: this.targetLine.attributes.lineType,
      }
    },
    createPayload(): CreatePayload {
      return {
        label: this.targetLine.attributes.label,
        amount: this.targetLine.attributes.amount,
        lineType: this.targetLine.attributes.lineType,
      }
    },
  },
  methods: {
    submitRequest(): () => Promise<any> {
      switch (this.$props.mode) {
        case LineFormMode.EDIT:
          return () => api.lines.updateOne(this.targetLine.id, this.updatePayload)
        case LineFormMode.CREATE:
          return () => api.lines.createOne(this.createPayload)
        default:
          return () => new Promise<any>((_, reject) => reject())
      }
    },
  },
}
</script>
