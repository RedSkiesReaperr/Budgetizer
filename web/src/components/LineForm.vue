<script setup lang="ts">
import {Line} from "@/api/resources/lines";
import {getTypeTranslationKey} from "@/services/types";

interface Props {
  target: Line;
  mode: LineFormMode;
  onSubmitting: () => void;
  onSubmitSuccess: () => void;
  onSubmitFailed: () => void;
  onSubmitted: () => void;
}

defineProps<Props>();
</script>

<template>
  <v-form ref="form" @submit.prevent="submit">
    <v-row>
      <v-col cols="12" sm="6" md="6">
        <v-text-field
          v-model="targetLine.attributes.label"
          :label="$t('operation.attributes.label')"
          :rules="rules.label"
          variant="outlined"
          clearable
          required
        ></v-text-field>
      </v-col>
      <v-col cols="12" md="3">
        <v-text-field
          v-model.number="targetLine.attributes.amount"
          :label="$t('operation.attributes.amount')"
          :rules="rules.amount"
          variant="outlined"
          type="number"
        ></v-text-field>
      </v-col>

      <v-col cols="12" sm="6" md="3">
        <v-select
          v-model="targetLine.attributes.lineType"
          :label="$t('operation.attributes.type')"
          :items="availableTypes"
          :rules="rules.type"
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
      </v-col>
    </v-row>
  </v-form>
</template>

<script lang="ts">
import TypeChip from "@/components/TypeChip.vue";
import api from "@/api";

export enum LineFormMode {
  EDIT,
  CREATE
}

const editRequest = api.lines.updateOne
const createRequest = api.lines.createOne

export default {
  data() {
    return {
      targetLine: this.$props.target,
      availableTypes: ["income", "vital", "non_essential"],
      rules: {
        label: [
          (value: string) =>
            value ? true : this.$t("form_validations.required"),
        ],
        amount: [
          (value: number) =>
            value && value > 0
              ? true
              : this.$t("form_validations.gt", {limit: 0}),
        ],
        type: [
          (value: string) =>
            value ? true : this.$t("form_validations.required"),
        ],
      }
    }
  },
  methods: {
    submit() {
      switch (this.$props.mode) {
        case LineFormMode.EDIT:
          this.launch(editRequest(this.targetLine.id, this.targetLine.attributes))
          break
        case LineFormMode.CREATE:
          this.launch(createRequest(this.targetLine.attributes))
          break
        default:
          console.error(`Invalid LineFormMode: ${this.$props.mode}`)
      }
    },
    async launch(req: Promise<any>) {
      this.$props.onSubmitting()
      await req
        .then(() => this.$props.onSubmitSuccess())
        .catch(() => this.$props.onSubmitFailed())
        .finally(() => this.$props.onSubmitted());
    },
  },
  components: {TypeChip}
}
</script>
