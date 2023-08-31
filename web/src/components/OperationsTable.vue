<script lang="ts" setup>
import { Operation } from "@/api/resources/operations";
import { VDataTable } from "vuetify/lib/labs/components.mjs";
import TypeChip from "@/components/TypeChip.vue";
import CategoryChip from "@/components/CategoryChip.vue";

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
      <span v-if="item.columns['attributes.pointed']">
        <v-icon icon="mdi-check-circle" color="green"></v-icon>
      </span>
      <span v-else>
        <v-icon icon="mdi-check-circle" color="grey"></v-icon>
      </span>
    </template>

    <template v-slot:[`item.actions`]="{ }">
      <v-icon size="small" class="me-2" @click="console.log('click')">
        mdi-square-edit-outline
      </v-icon>
    </template>
  </v-data-table>
</template>

<script lang="ts">
export default {
  data() {
    return {
      itemsPerPage: 20,
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
          title: this.$t("action", 2),
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
      const amount = rawAmount.toFixed(2);

      return rawAmount > 0 ? `+${amount} €` : `${amount} €`;
    },
  },
};
</script>
