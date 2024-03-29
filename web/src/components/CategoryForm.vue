<script setup lang="ts">
import Form from "@/components/Form.vue";
import {Category} from "@/api/resources/categories";
import CategoryChip from "@/components/CategoryChip.vue";

interface Props {
  target: Category;
  mode: CategoryFormMode;
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
      <v-col cols="12" xs="12" sm="6" md="6" lg="6" xl="6" xxl="6">
        <v-text-field
          v-model="targetCategory.attributes.key"
          :label="$t('resource.category.attributes.key')"
          :rules="rules.key"
          variant="outlined"
          clearable
          required
        ></v-text-field>
      </v-col>

      <v-col cols="12" xs="12" sm="6" md="6" lg="6" xl="6" xxl="6">
        <v-text-field
          v-model="iconModel"
          :label="$t('resource.category.attributes.icon')"
          :rules="rules.icon"
          :prefix="ICON_PREFIX"
          variant="outlined"
        >
          <template v-slot:append-inner>
            <v-fade-transition leave-absolute>
              <v-icon aria-hidden="false">{{ iconValue }}</v-icon>
            </v-fade-transition>
          </template>
        </v-text-field>
      </v-col>
    </v-row>

    <v-row justify="center">
      <v-col cols="12" xs="12" sm="12" md="6" lg="6" xl="6" xxl="6">
        <v-row class="pt-2" justify="center">
          <v-color-picker v-model="targetCategory.attributes.color" mode="hexa" :hide-inputs="true"/>
        </v-row>
      </v-col>

      <v-col align-self="center" cols="12" xs="12" sm="12" md="6" lg="6" xl="6" xxl="6">
        <v-row class="pt-2" justify="center">
          <CategoryChip :category="targetPreview" size="default"></CategoryChip>
        </v-row>
      </v-col>
    </v-row>
  </Form>
</template>

<script lang="ts">
import api from "@/api";
import {CreatePayload, UpdatePayload} from "@/api/resources/categories";

export enum CategoryFormMode {CREATE, EDIT}

const ICON_PREFIX = "mdi-"

export default {
  data() {
    return {
      iconModel: this.transformIcon(this.$props.target.attributes.icon),
      targetCategory: this.$props.target,
      rules: {
        key: [
          (value: string) =>
            value ? true : this.$t("form_validations.required"),
          (value: string) =>
            /^[a-z][_a-z]+[a-z]$/.test(value) ? true : this.$t("form_validations.category.key.invalid_format"),
        ],
        icon: [
          (value: string) =>
            value ? true : this.$t("form_validations.required"),
        ],
      }
    }
  },
  computed: {
    iconValue(): string {
      return ICON_PREFIX + this.iconModel
    },
    targetPreview(): Category {
      return {attributes: {...this.targetCategory.attributes, icon: this.iconValue}} as Category
    },
    createPayload(): CreatePayload {
      return {
        key: this.targetCategory.attributes.key,
        color: this.targetCategory.attributes.color,
        icon: this.iconValue,
      }
    },
    updatePayload(): UpdatePayload {
      return {
        key: this.targetCategory.attributes.key,
        color: this.targetCategory.attributes.color,
        icon: this.iconValue,
      }
    },
  },
  methods: {
    transformIcon(raw: string): string {
      return (raw.startsWith(ICON_PREFIX)) ? raw.replace(ICON_PREFIX, '') : raw
    },
    submitRequest(): () => Promise<any> {
      switch (this.$props.mode) {
        case CategoryFormMode.CREATE:
          return () => api.categories.createOne(this.createPayload)
        case CategoryFormMode.EDIT:
          return () => api.categories.updateOne(this.targetCategory.id, this.createPayload)
        default:
          return () => new Promise<any>((_, reject) => reject())
      }
    },
  },
  components: {}
}
</script>
