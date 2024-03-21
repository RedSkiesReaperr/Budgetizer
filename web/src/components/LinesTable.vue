<script setup lang="ts">
import {LineFormMode} from "@/components/LineForm.vue";
import ConfirmationModal from "@/components/ConfirmationModal.vue";

interface Props {
  lines: Line[];
  onLinesChanged: () => Promise<any>;
}

const props = defineProps<Props>();
</script>

<template>
  <v-data-table
    :items-per-page="itemsPerPage"
    :headers="headers"
    :items="props.lines"
    :sort-by="[{ key: 'attributes.amount', order: 'desc' }]"
    density="compact"
  >
    <template v-slot:[`item.attributes.lineType`]="{ item }">
      <TypeChip
        :raw-type="item.attributes.lineType"
        size="small"
      ></TypeChip>
    </template>

    <template v-slot:[`item.attributes.amount`]="{ item }">
      <span>{{ formatAmount(item.attributes.amount) }}</span>
    </template>

    <template v-slot:[`item.actions`]="{ item }">
      <v-icon
        size="small"
        class="me-2"
        @click="openEditLine(item)"
        color="blue"
      >
        mdi-square-edit-outline
      </v-icon>
      <v-icon
        size="small"
        class="me-2"
        @click="openDeleteDialog(item)"
        color="red"
      >
        mdi-trash-can-outline
      </v-icon>
    </template>
  </v-data-table>

  <ConfirmationModal :is-open="editDialog" :on-canceled="closeEditDialog" :on-confirmed="confirmEdit">
    <template v-slot:title>{{ $t("line.edition.title") }}</template>
    <template v-slot:content>
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

        <LineForm
          ref="lineFormEdit"
          :mode="LineFormMode.EDIT"
          :target="editedLine"
          :on-submitting="editSubmitting"
          :on-submit-success="editSucceed"
          :on-submit-failed="editFailed"
          :on-submitted="editSubmitted"
        />
      </v-container>
    </template>
  </ConfirmationModal>

  <ConfirmationModal :is-open="deleteDialog" :on-canceled="closeDeleteDialog" :on-confirmed="confirmDelete">
    <template v-slot:title>{{ $t("line.deletion.title") }}</template>
    <template v-slot:subtitle>{{ $t("line.deletion.body") }}</template>
    <template v-slot:content>
      <p>
        <b>{{ $t("line.attributes.id") }}:</b>
        <i>{{ deletingLine.id }}</i>
      </p>
      <p>
        <b>{{ $t("line.attributes.label") }}:</b>
        <i>{{ deletingLine.attributes.label }}</i>
      </p>
      <p>
        <b>{{ $t("line.attributes.amount") }}:</b>
        <i>{{ formatAmount(deletingLine.attributes.amount) }}</i>
      </p>
      <p>
        <b>{{ $t("line.attributes.type") }}:</b>
        <TypeChip
          :raw-type="deletingLine.attributes.lineType"
          size="small"
        ></TypeChip>
      </p>
    </template>
  </ConfirmationModal>
</template>

<script lang="ts">
import TypeChip from "@/components/TypeChip.vue";
import LineForm from "@/components/LineForm.vue";
import {Line} from "@/api/resources/lines";
import api from "@/api";
import {copyLine} from "@/services/lines";
import {formatAmount} from '@/services/formatters'

export default {
  data() {
    return {
      itemsPerPage: 30,
      // Delete Line
      deleteDialog: false,
      deletingLine: {} as Line,
      // Edit Line
      editDialog: false,
      editLoading: false,
      editError: false,
      editedLine: {} as Line,
    };
  },
  computed: {
    headers() {
      return [
        {
          title: this.$t("line.attributes.type"),
          sortable: true,
          key: "attributes.lineType",
        },
        {
          title: this.$t("line.attributes.label"),
          sortable: true,
          key: "attributes.label",
        },
        {
          title: this.$t("line.attributes.amount"),
          sortable: true,
          key: "attributes.amount",
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
    openEditLine(item: Line) {
      this.editedLine = copyLine(item);
      this.editDialog = true;
    },
    closeEditDialog() {
      this.editDialog = false;
      this.editError = false
    },
    confirmEdit() {
      (this.$refs.lineFormEdit as any).$refs.form.$refs.form.requestSubmit()
    },
    editSubmitting() {
      this.editLoading = true
    },
    editSucceed() {
      this.$props.onLinesChanged().then(() => this.closeEditDialog())
    },
    editFailed() {
      this.editError = true
    },
    editSubmitted() {
      this.editLoading = false
    },
    openDeleteDialog(line: Line) {
      this.deletingLine = line;
      this.deleteDialog = true;
    },
    closeDeleteDialog() {
      this.deleteDialog = false;
    },
    async confirmDelete() {
      await api.lines
        .deleteOne(this.deletingLine.id)
        .then(() => this.$props.onLinesChanged())
        .finally(() => this.deleteDialog = false);
    },
  },
  components: {TypeChip, LineForm},
};
</script>