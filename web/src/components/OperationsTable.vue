<script lang="ts" setup>
import { Operation } from "@/api/resources/operations";
import { VDataTable } from "vuetify/lib/labs/components.mjs";
import TypeChip from "@/components/TypeChip.vue";

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

    <template v-slot:[`item.attributes.pointed`]="{ item }">
      <span v-if="item.columns['attributes.date']">
        <v-icon icon="mdi-check-circle" color="green"></v-icon>
      </span>
      <span v-else>
        <v-icon icon="mdi-check-circle" color="grey"></v-icon>
      </span>
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
      ];
    },
  },
};
</script>
