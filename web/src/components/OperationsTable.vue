<script lang="ts" setup>
import TypeChip from "@/components/TypeChip.vue";
import CategoryChip from "@/components/CategoryChip.vue";
import Alert from "@/components/Alert.vue";
import {Category} from "@/api/resources/categories";
import {getCategoryById} from "@/services/categories";
import OperationForm, {OperationFormMode} from "@/components/OperationForm.vue";
import ConfirmationModal from "@/components/ConfirmationModal.vue";

interface Props {
  operations: Operation[];
  categories: Category[];
}

const props = defineProps<Props>();
defineEmits(['operationChange'])
</script>

<template>
  <v-data-table
    :items-per-page="itemsPerPage"
    :headers="headers"
    :items="props.operations"
    :sort-by="[{ key: 'attributes.date', order: 'desc' }]"
  >
    <template v-slot:[`item.attributes.date`]="{ item }">
      <span>{{ new Date(item.attributes.date).toLocaleDateString($i18n.locale) }}</span>
    </template>

    <template v-slot:[`item.attributes.opType`]="{ item }">
      <TypeChip
        :raw-type="item.attributes.opType"
        size="small"
      ></TypeChip>
    </template>

    <template v-slot:[`item.attributes.category`]="{ item }">
      <CategoryChip
        :category="getCategoryById(item.attributes.categoryId, props.categories)"
        size="small"
      ></CategoryChip>
    </template>

    <template v-slot:[`item.attributes.amount`]="{ item }">
      <span
        :style="{
          color: isIncome(item.attributes.amount) ? 'green' : 'red',
        }"
      ><b>{{ formattedAmount(item.attributes.amount) }}</b></span
      >
    </template>

    <template v-slot:[`item.attributes.comment`]="{ item }">
      <span :style="{ opacity: 0.8 }">
        <i>{{ item.attributes.comment }}</i>
      </span>
    </template>

    <template v-slot:[`item.attributes.pointed`]="{ item }">
      <span>
        <v-icon
          icon="mdi-check-circle"
          :color="item.attributes.pointed ? 'green' : 'grey'"
          v-on:click="pointOperation(item)"
        />
      </span>
    </template>

    <template v-slot:[`item.actions`]="{ item }">
      <v-icon size="small" class="me-2" @click="editOperation(item)">
        mdi-square-edit-outline
      </v-icon>
    </template>
  </v-data-table>

  <ConfirmationModal :is-open="editDialog" :loading="editLoading" @cancel="closeEditDialog" @confirm="saveOperation">
    <template v-slot:title>{{ $t("operation.edition.title") }}</template>
    <template v-slot:content>
      <v-container>
        <OperationForm ref="operationFormEdit"
                       :mode="OperationFormMode.EDIT"
                       @submit="editSubmitting"
                       @success="editSucceed"
                       @fail="(err: any) => editFailed()"
                       @finish="editSubmitted"
                       :target="editedOperation"/>
      </v-container>
    </template>
  </ConfirmationModal>

  <Alert></Alert>
</template>

<script lang="ts">
import {AlertType, useAlertStore} from "@/stores/alert";
import {copyOperation} from "@/services/operations";
import {formatNumber} from "@/services/formatters";
import api from "@/api";
import {Operation} from "@/api/resources/operations";

const alertStore = useAlertStore()

export default {
  data() {
    return {
      itemsPerPage: 20,
      editDialog: false,
      editLoading: false,
      editedOperation: {} as Operation,
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
  },
  methods: {
    isIncome(amount: number): boolean {
      return amount > 0;
    },
    formattedAmount(rawAmount: number): string {
      const amount = formatNumber(rawAmount);

      return rawAmount > 0 ? `+${amount} €` : `${amount} €`;
    },
    editSubmitting() {
      this.editLoading = true
    },
    editSucceed() {
      alertStore.show(AlertType.Success, this.$t('operation.edition.success_title'), this.$t("operation.edition.success_message"))
      this.$emit('operationChange')
      this.closeEditDialog()
    },
    editFailed() {
      alertStore.show(AlertType.Error, this.$t('operation.edition.error'), this.$t("something_went_wrong"))
    },
    editSubmitted() {
      this.editLoading = false
    },
    editOperation(item: Operation) {
      this.editedOperation = copyOperation(item);
      this.editDialog = true;
    },
    closeEditDialog() {
      this.editDialog = false;
    },
    async pointOperation(item: Operation) {
      const newPointedValue = !item.attributes.pointed;

      await api.operations
        .updateOne(item.id, {pointed: newPointedValue})
        .then(() => item.attributes.pointed = newPointedValue);
    },
    saveOperation() {
      (this.$refs.operationFormEdit as any).$refs.form.$refs.form.requestSubmit()
    },
  },
};
</script>
