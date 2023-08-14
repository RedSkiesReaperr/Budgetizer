<template>
  <BasicCard :loading="appStore.currentBudgetLines.length <= 0">
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
</template>

<script lang="ts">
import { useAppStore } from "@/stores/app";
import { VDataTable } from "vuetify/lib/labs/components.mjs";
import BasicCard from "@/components/BasicCard.vue";
import TypeChip from "@/components/TypeChip.vue";

export default {
  setup() {
    const appStore = useAppStore();

    return { appStore };
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
  components: { VDataTable, BasicCard, TypeChip },
};
</script>
