<template>
  <div
    v-if="appStore.currentBudgetObjective.attributes"
    class="mb-6 d-flex flex-row justify-center flex-wrap flex-grow-1"
    :style="{ gap: '18px' }"
  >
    <InfoCard
      v-for="(f, i) in forecast()"
      v-bind:key="i"
      :loading="appStore.currentBudgetLines.length <= 0"
    >
      <template v-slot:main>
        <GaugeChart
          :label="$t(f.translationKey)"
          :color="getTypeColor(i)"
          :value="f.totalAmount"
          :max-value="f.objectiveTarget"
        ></GaugeChart>
      </template>
      <template v-slot:info>{{
        $t("forecast_page.card_info", {
          type: $t(f.translationKey),
          budgetTargetAmount: f.objectiveTarget.toFixed(2),
          valueAmount: f.totalAmount.toFixed(2),
          diffValue: f.diffAmount.toFixed(2),
          diffPerentage: f.diffPercentage,
        })
      }}</template>
    </InfoCard>
  </div>

  <div class="d-flex flex-row flex-wrap">
    <BasicCard
      class="pb-10 flex-grow-1"
      :loading="appStore.currentBudgetLines.length <= 0"
    >
      <v-btn
        icon="mdi-plus-circle-outline"
        variant="text"
        color="green"
        :style="{ position: 'absolute', top: 0, right: 0 }"
        @click="openCreateLine"
      >
      </v-btn>
      <v-data-table
        :items-per-page="itemsPerPage"
        :headers="headers"
        :items="appStore.currentBudgetLines"
        :sort-by="[{ key: 'attributes.amount', order: 'desc' }]"
        density="compact"
      >
        <template v-slot:[`item.attributes.lineType`]="{ item }">
          <TypeChip
            :raw-type="item.columns['attributes.lineType']"
            size="small"
          ></TypeChip>
        </template>

        <template v-slot:[`item.attributes.amount`]="{ item }">
          <span>{{ formattedAmount(item.columns["attributes.amount"]) }}</span>
        </template>

        <template v-slot:[`item.actions`]="{ item }">
          <v-icon
            size="small"
            class="me-2"
            @click="editLine(item.raw)"
            color="blue"
          >
            mdi-square-edit-outline
          </v-icon>
          <v-icon
            size="small"
            class="me-2"
            @click="openDeleteDialog(item.raw)"
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
                      :items="typeItems"
                      item-title="title"
                      item-value="value"
                      variant="outlined"
                    >
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

      <v-row justify="center">
        <v-dialog v-model="createDialog" persistent>
          <v-card>
            <v-card-title class="pt-4">
              <span class="text-h5">{{ $t("line.creation.title") }}</span>
            </v-card-title>
            <v-card-text>
              <v-container>
                <v-overlay
                  class="align-center justify-center"
                  :model-value="createLoading"
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

                <v-form ref="createForm">
                  <v-row>
                    <v-col cols="12" sm="6" md="6">
                      <v-text-field
                        v-model="createdLine.attributes.label"
                        :label="$t('operation.attributes.label')"
                        variant="outlined"
                        :rules="createRules.label"
                        clearable
                        required
                      ></v-text-field>
                    </v-col>
                    <v-col cols="12" md="3">
                      <v-text-field
                        v-model="createdLine.attributes.amount"
                        :label="$t('operation.attributes.amount')"
                        variant="outlined"
                        type="number"
                        :rules="createRules.amount"
                      ></v-text-field>
                    </v-col>

                    <v-col cols="12" sm="6" md="3">
                      <v-select
                        v-model="createdLine.attributes.lineType"
                        small-chips
                        default="createdLine.attributes.lineType"
                        :label="$t('operation.attributes.type')"
                        :items="typeItems"
                        :rules="createRules.type"
                        item-title="title"
                        item-value="value"
                        variant="outlined"
                      >
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
              </v-container>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-alert
                closable
                v-model="createError"
                :text="$t('operation.edition.error')"
                type="error"
                variant="tonal"
              ></v-alert>
              <v-spacer></v-spacer>
              <v-btn
                color="blue-darken-1"
                variant="text"
                @click="closeCreateDialog"
              >
                {{ $t("actions.cancel") }}
              </v-btn>
              <v-btn color="blue-darken-1" variant="text" @click="createLine">
                {{ $t("actions.create") }}
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
          <v-card-title class="text-h5"
            >{{ $t("line.deletion.title") }}
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
              <i>{{ deletingLine.attributes.amount }}</i>
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
    </BasicCard>
  </div>
</template>

<script lang="ts">
import { useAppStore } from "@/stores/app";
import { VDataTable } from "vuetify/lib/labs/components.mjs";
import BasicCard from "@/components/BasicCard.vue";
import InfoCard from "@/components/InfoCard.vue";
import GaugeChart from "@/components/GaugeChart.vue";
import TypeChip from "@/components/TypeChip.vue";
import { getTypeColor } from "@/services/types";
import { percentageToValue } from "@/services/calculations";
import { Line } from "@/api/resources/lines";
import api from "@/api";
import { copyLine } from "@/services/lines";
import {
  knownCategories,
  getCategoryTranslationKey,
} from "@/services/categories";
import { VForm } from "vuetify/lib/components/index.mjs";

export default {
  setup() {
    const appStore = useAppStore();

    return {
      appStore,
      getTypeColor,
    };
  },
  data() {
    return {
      itemsPerPage: 30,
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
      // Create Line
      createDialog: false,
      createError: false,
      createLoading: false,
      createdLine: {} as Line,
      createRules: {
        label: [
          (value: string) =>
            value ? true : this.$t("form_validations.required"),
        ],
        amount: [
          (value: number) =>
            value && value > 0
              ? true
              : this.$t("form_validations.gt", { limit: 0 }),
        ],
        type: [
          (value: string) =>
            value ? true : this.$t("form_validations.required"),
        ],
      },
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
  },
  methods: {
    forecast() {
      return {
        vital: {
          translationKey: "operation.types.vital",
          objectiveTarget: percentageToValue(
            this.appStore.currentBudgetObjective.attributes.vital,
            this.appStore.forecastIncome
          ),
          totalAmount: this.appStore.forecastVital,
          diffAmount: this.appStore.forecastVitalDiffValue,
          diffPercentage: this.formattedPercentage(
            this.appStore.forecastVitalDiffPercentage
          ),
        },
        non_essential: {
          translationKey: "operation.types.non_essential",
          objectiveTarget: percentageToValue(
            this.appStore.currentBudgetObjective.attributes.nonEssential,
            this.appStore.forecastIncome
          ),
          totalAmount: this.appStore.forecastNonEssential,
          diffAmount: this.appStore.forecastNonEssentialDiffValue,
          diffPercentage: this.formattedPercentage(
            this.appStore.forecastNonEssentialDiffPercentage
          ),
        },
        saving: {
          translationKey: "saving",
          objectiveTarget: percentageToValue(
            this.appStore.currentBudgetObjective.attributes.saving,
            this.appStore.forecastIncome
          ),
          totalAmount: this.appStore.forecastSaving,
          diffAmount: this.appStore.forecastSavingDiffValue,
          diffPercentage: this.formattedPercentage(
            this.appStore.forecastSavingDiffPercentage
          ),
        },
      };
    },
    formattedAmount(rawAmount: number): string {
      return `${rawAmount.toFixed(2)} €`;
    },
    formattedPercentage(value: number): string {
      const perc = value.toFixed(2);

      return value >= 0 ? `+${perc}` : perc;
    },
    editLine(item: Line) {
      this.editedLineIndex = this.appStore.currentBudgetLines.indexOf(item);
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
          .then((res) => {
            Object.assign(
              this.appStore.currentBudgetLines[this.editedLineIndex],
              res
            );
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
    openCreateLine() {
      this.createdLine = copyLine(this.defaultLine);
      this.createDialog = true;
    },
    async createLine() {
      const { valid } = await (this.$refs.createForm as VForm).validate();

      if (valid) {
        const createPayload = {
          label: this.createdLine.attributes.label,
          amount: this.createdLine.attributes.amount,
          lineType: this.createdLine.attributes.lineType,
          category: this.createdLine.attributes.category,
        };

        this.createLoading = true;
        await api.lines
          .createOne(this.appStore.currentBudget.id, createPayload)
          .then((res) => {
            this.appStore.currentBudgetLines.push(res);
            this.closeCreateDialog();
          })
          .catch(() => {
            this.createError = true;
          })
          .finally(() => {
            this.createLoading = false;
          });
      }
    },
    closeCreateDialog() {
      this.createDialog = false;
    },
    openDeleteDialog(line: Line) {
      this.deletingLine = line;
      this.deletingLineIndex = this.appStore.currentBudgetLines.indexOf(line);
      this.deleteDialog = true;
    },
    closeDeleteDialog() {
      this.deleteDialog = false;
    },
    async confirmDelete() {
      await api.lines
        .deleteOne(this.deletingLine.id)
        .then(() => {
          this.appStore.currentBudgetLines.splice(this.deletingLineIndex, 1);
        })
        .finally(() => {
          this.deleteDialog = false;
        });
    },
  },
  components: { VDataTable, GaugeChart, BasicCard, TypeChip, InfoCard },
};
</script>
