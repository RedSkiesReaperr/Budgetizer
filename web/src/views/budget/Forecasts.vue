<template>
  <div
    class="mb-6 d-flex flex-row justify-center flex-wrap flex-grow-1"
    :style="{ gap: '18px' }"
  >
    <BasicCard :loading="appStore.currentBudgetLines.length <= 0">
      <GaugeChart
        :label="$t('operation.types.vital')"
        :color="getTypeColor('vital')"
        :value="1426.63"
        :max-value="1290.58"
      ></GaugeChart>
    </BasicCard>
    <BasicCard :loading="appStore.currentBudgetLines.length <= 0">
      <GaugeChart
        :label="$t('operation.types.non_essential')"
        :color="getTypeColor('non_essential')"
        :value="544.98"
        :max-value="774.35"
      ></GaugeChart>
    </BasicCard>
    <BasicCard :loading="appStore.currentBudgetLines.length <= 0">
      <GaugeChart
        :label="$t('saving', 2)"
        :color="getTypeColor('saving')"
        :value="698.54"
        :max-value="516.23"
      ></GaugeChart>
    </BasicCard>
  </div>

  <div class="d-flex flex-row flex-wrap">
    <BasicCard
      class="flex-grow-1"
      :loading="appStore.currentBudgetLines.length <= 0"
    >
      <v-data-table
        :items-per-page="itemsPerPage"
        :headers="headers"
        :items="appStore.currentBudgetLines"
        :sort-by="[{ key: 'attributes.lineType', order: 'desc' }]"
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

        <template v-slot:[`item.actions`]="{}">
          <v-icon size="small" class="me-2" @click="console.log('click')">
            mdi-square-edit-outline
          </v-icon>
        </template>
      </v-data-table>
    </BasicCard>
  </div>
</template>

<script lang="ts">
import { useAppStore } from "@/stores/app";
import { VDataTable } from "vuetify/lib/labs/components.mjs";
import BasicCard from "@/components/BasicCard.vue";
import GaugeChart from "@/components/GaugeChart.vue";
import TypeChip from "@/components/TypeChip.vue";
import { getTypeColor } from "@/services/types";

export default {
  setup() {
    const appStore = useAppStore();

    return { appStore, getTypeColor };
  },
  data() {
    return {
      itemsPerPage: 30,
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
          title: this.$t("action", 2),
          sortable: false,
          key: "actions",
        },
      ];
    },
  },
  methods: {
    formattedAmount(rawAmount: number): string {
      return `${rawAmount.toFixed(2)} €`;
    },
  },
  components: { VDataTable, GaugeChart, BasicCard, TypeChip },
};
</script>
