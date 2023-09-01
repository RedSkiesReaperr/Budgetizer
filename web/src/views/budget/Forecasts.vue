<template>
  <div
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
          <v-icon size="small" class="me-2" @click="editLine(item.raw)">
            mdi-square-edit-outline
          </v-icon>
          <v-icon size="small" class="me-2" @click="console.log('click')">
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
                Close
              </v-btn>
              <v-btn color="blue-darken-1" variant="text" @click="saveLine">
                Save
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-row>
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
            this.forecast();
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
  components: { VDataTable, GaugeChart, BasicCard, TypeChip, InfoCard },
};
</script>
