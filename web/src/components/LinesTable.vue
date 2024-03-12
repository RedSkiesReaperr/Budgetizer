<script setup lang="ts">
import {formatNumber} from "@/services/formatters";

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
        @click="editLine(item)"
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
              <v-col cols="12" sm="6" md="6">
                <v-text-field
                  v-model="editedLine.attributes.label"
                  :label="$t('operation.attributes.label')"
                  variant="outlined"
                  clearable
                  required
                ></v-text-field>
              </v-col>
              <v-col cols="12" md="3">
                <v-text-field
                  v-model="editedLine.attributes.amount"
                  :label="$t('operation.attributes.amount')"
                  variant="outlined"
                  type="number"
                ></v-text-field>
              </v-col>

              <v-col cols="12" sm="6" md="3">
                <v-select
                  v-model="editedLine.attributes.lineType"
                  small-chips
                  default="editedLine.attributes.lineType"
                  :label="$t('operation.attributes.type')"
                  :items="availableTypes"
                  item-value="value"
                  variant="outlined"
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
          <v-btn
            color="blue-darken-1"
            variant="text"
            @click="closeEditDialog"
          >
            {{ $t("actions.cancel") }}
          </v-btn>
          <v-btn color="blue-darken-1" variant="text" @click="saveLine">
            {{ $t("actions.save") }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>

  <v-dialog
    v-model="deleteDialog"
    persistent
    width="auto"
    transition="fade-transition"
  >
    <v-card>
      <v-card-title class="text-h5">
        {{ $t("line.deletion.title") }}
      </v-card-title>
      <v-card-text>
        <p>{{ $t("line.deletion.body") }}</p>
        <v-divider class="my-2"></v-divider>
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
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn variant="text" @click="closeDeleteDialog">
          {{ $t("actions.cancel") }}
        </v-btn>
        <v-btn color="red" variant="text" @click="confirmDelete">
          {{ $t("actions.delete") }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script lang="ts">
import TypeChip from "@/components/TypeChip.vue";
import {getTypeTranslationKey} from "@/services/types";
import {Line} from "@/api/resources/lines";
import api from "@/api";
import {copyLine} from "@/services/lines";
import {formatAmount} from '@/services/formatters'

export default {
  data() {
    return {
      itemsPerPage: 30,
      availableTypes: ["income", "vital", "non_essential"],
      // Delete Line
      deleteDialog: false,
      deletingLine: {} as Line,
      deletingLineIndex: -1,
      // Edit Line
      editDialog: false,
      editLoading: false,
      editError: false,
      defaultLine: {} as Line,
      editedLine: {} as Line,
      editedLineIndex: -1,
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
    editLine(item: Line) {
      this.editedLineIndex = this.$props.lines.indexOf(item)
      this.editedLine = copyLine(item);
      this.editDialog = true;
    },
    closeEditDialog() {
      this.editDialog = false;
    },
    async saveLine() {
      if (this.editedLineIndex > -1) {
        const editPayload = {
          label: this.editedLine.attributes.label,
          amount: this.editedLine.attributes.amount,
          lineType: this.editedLine.attributes.lineType,
          category: this.editedLine.attributes.category,
        };

        this.editLoading = true;
        await api.lines
          .updateOne(this.editedLine.id, editPayload)
          .then(() => {
            this.$props.onLinesChanged().then(() => this.closeEditDialog())
          })
          .catch(() => this.editError = true)
          .finally(() => this.editLoading = false);
      }
    },
    openDeleteDialog(line: Line) {
      this.deletingLine = line;
      this.deletingLineIndex = this.$props.lines.indexOf(line)
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
  components: {TypeChip},
};
</script>
