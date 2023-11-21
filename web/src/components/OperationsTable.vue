<script lang="ts" setup>
import { Operation } from "@/api/resources/operations";
import { VDataTable } from "vuetify/lib/labs/components.mjs";
import TypeChip from "@/components/TypeChip.vue";
import CategoryChip from "@/components/CategoryChip.vue";
import api from "@/api";
import {
  knownCategories,
  getCategoryTranslationKey,
} from "@/services/categories";
import { copyOperation } from "@/services/operations";
import { formatNumber } from "@/services/formatters";

interface Props {
  data: Operation[];
}
const props = defineProps<Props>();
</script>

<template>
  <v-data-table
    :items-per-page="itemsPerPage"
    :headers="headers"
    :items="props.data"
    :sort-by="[{ key: 'attributes.date', order: 'desc' }]"
  >
    <template v-slot:[`item.attributes.date`]="{ item }">
      <span>{{
        new Date(item.columns["attributes.date"]).toLocaleDateString(
          $i18n.locale
        )
      }}</span>
    </template>

    <template v-slot:[`item.attributes.opType`]="{ item }">
      <TypeChip
        :raw-type="item.columns['attributes.opType']"
        size="small"
      ></TypeChip>
    </template>

    <template v-slot:[`item.attributes.category`]="{ item }">
      <CategoryChip
        :raw-category="item.columns['attributes.category']"
        size="small"
      ></CategoryChip>
    </template>

    <template v-slot:[`item.attributes.amount`]="{ item }">
      <span
        :style="{
          color: isIncome(item.columns['attributes.amount']) ? 'green' : 'red',
        }"
        ><b>{{ formattedAmount(item.columns["attributes.amount"]) }}</b></span
      >
    </template>

    <template v-slot:[`item.attributes.comment`]="{ item }">
      <span :style="{ opacity: 0.8 }">
        <i>{{ item.columns["attributes.comment"] }}</i>
      </span>
    </template>

    <template v-slot:[`item.attributes.pointed`]="{ item }">
      <span>
        <v-icon
          icon="mdi-check-circle"
          :color="item.columns['attributes.pointed'] ? 'green' : 'grey'"
          v-on:click="pointOperation(item.raw)"
        />
      </span>
    </template>

    <template v-slot:[`item.actions`]="{ item }">
      <v-icon size="small" class="me-2" @click="editOperation(item.raw)">
        mdi-square-edit-outline
      </v-icon>
    </template>
  </v-data-table>

  <v-row justify="center">
    <v-dialog v-model="editDialog" persistent>
      <v-card>
        <v-card-title class="pt-4">
          <span class="text-h5">{{ $t("operation.edition.title") }}</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-overlay
              class="align-center justify-center"
              :model-value="editLoading"
              :close-on-content-click="false"
              contained
              disabled
              persistent
            >
              <v-progress-circular
                color="primary"
                indeterminate
              ></v-progress-circular>
            </v-overlay>

            <v-row>
              <v-col cols="12" sm="6" md="3">
                <v-text-field
                  v-model="editedOperationDate"
                  :label="$t('operation.attributes.date')"
                  variant="outlined"
                  disabled
                ></v-text-field>
              </v-col>

              <v-col cols="12" sm="6" md="6">
                <v-text-field
                  v-model="editedOperation.attributes.label"
                  :label="$t('operation.attributes.label')"
                  variant="outlined"
                  clearable
                  required
                ></v-text-field>
              </v-col>
              <v-col cols="12" md="3">
                <v-text-field
                  v-model="editedOperation.attributes.amount"
                  :label="$t('operation.attributes.amount')"
                  variant="outlined"
                  disabled
                ></v-text-field>
              </v-col>

              <v-col cols="12" sm="6" md="4">
                <v-select
                  v-model="editedOperation.attributes.opType"
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
                  v-model="editedOperation.attributes.category"
                  small-chips
                  :label="$t('operation.attributes.category')"
                  :items="categoryItems"
                  item-title="title"
                  item-value="value"
                  variant="outlined"
                >
                  <template #selection="{ item }">
                    <CategoryChip
                      :raw-category="item.value"
                      size="small"
                    ></CategoryChip>
                  </template>
                </v-select>
              </v-col>
              <v-col cols="12" md="2">
                <v-switch
                  v-model="editedOperation.attributes.pointed"
                  :label="$t('operation.attributes.pointed')"
                  color="green"
                  true-icon="mdi-check-circle-outline"
                  false-icon="mdi-close-circle-outline"
                  inset
                ></v-switch>
              </v-col>
              <v-col cols="12" md="12">
                <v-text-field
                  v-model="editedOperation.attributes.comment"
                  :label="$t('operation.attributes.comment')"
                  required
                  variant="outlined"
                  clearable
                ></v-text-field>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-alert
            closable
            v-model="editError"
            :text="$t('operation.edition.error')"
            type="error"
            variant="tonal"
          ></v-alert>
          <v-spacer></v-spacer>
          <v-btn color="blue-darken-1" variant="text" @click="closeEditDialog">
            Close
          </v-btn>
          <v-btn color="blue-darken-1" variant="text" @click="saveOperation">
            Save
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script lang="ts">
export default {
  data() {
    return {
      itemsPerPage: 20,
      editDialog: false,
      editLoading: false,
      editError: false,
      defaultOperation: {} as Operation,
      editedOperation: {} as Operation,
      editedOperationIndex: -1,
    };
  },
  computed: {
    headers() {
      return [
        {
          title: this.$t("operation.attributes.date"),
          sortable: true,
          key: "attributes.date",
        },
        {
          title: this.$t("operation.attributes.label"),
          sortable: true,
          key: "attributes.label",
        },
        {
          title: this.$t("operation.attributes.type"),
          sortable: true,
          key: "attributes.opType",
        },
        {
          title: this.$t("operation.attributes.category"),
          sortable: true,
          key: "attributes.category",
        },
        {
          title: this.$t("operation.attributes.amount"),
          sortable: true,
          key: "attributes.amount",
        },
        {
          title: this.$t("operation.attributes.comment"),
          sortable: false,
          key: "attributes.comment",
        },
        {
          title: this.$t("operation.attributes.pointed"),
          sortable: true,
          key: "attributes.pointed",
        },
        {
          title: "",
          sortable: false,
          key: "actions",
        },
      ];
    },
    typeItems() {
      return [
        { value: "income", title: this.$t("operation.types.income") },
        { value: "vital", title: this.$t("operation.types.vital") },
        {
          value: "non_essential",
          title: this.$t("operation.types.non_essential"),
        },
      ];
    },
    categoryItems(): Array<{ value: string; title: string }> {
      let items: Array<{ value: string; title: string }> = [];

      knownCategories.forEach((cat) => {
        items.push({
          value: cat,
          title: this.$t(getCategoryTranslationKey(cat)),
        });
      });

      return items;
    },
    editedOperationDate() {
      return new Date(this.editedOperation.attributes.date).toLocaleDateString(
        this.$i18n.locale
      );
    },
  },
  methods: {
    isIncome(amount: number): boolean {
      return amount > 0;
    },
    formattedAmount(rawAmount: number): string {
      const amount = formatNumber(rawAmount);

      return rawAmount > 0 ? `+${amount} €` : `${amount} €`;
    },
    editOperation(item: Operation) {
      this.editedOperationIndex = this.$props.data.indexOf(item);
      this.editedOperation = copyOperation(item);
      this.editDialog = true;
    },
    closeEditDialog() {
      this.editDialog = false;
    },
    async pointOperation(item: Operation) {
      const newPointedValue = !item.attributes.pointed;

      await api.operations
        .updateOne(item.id, { pointed: newPointedValue })
        .then(() => {
          item.attributes.pointed = newPointedValue;
        });
    },
    async saveOperation() {
      if (this.editedOperationIndex > -1) {
        const editPayload = {
          label: this.editedOperation.attributes.label,
          pointed: this.editedOperation.attributes.pointed,
          comment: this.editedOperation.attributes.comment,
          opType: this.editedOperation.attributes.opType,
          category: this.editedOperation.attributes.category,
        };

        this.editLoading = true;
        await api.operations
          .updateOne(this.editedOperation.id, editPayload)
          .then((res) => {
            Object.assign(this.$props.data[this.editedOperationIndex], res);
            this.closeEditDialog();
          })
          .catch(() => {
            this.editError = true;
          })
          .finally(() => {
            this.editLoading = false;
          });
      }
    },
  },
};
</script>
