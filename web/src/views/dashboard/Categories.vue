<template>
  <template v-if="categoriesStore.fetching">
    <v-skeleton-loader :elevation="0" type="card"></v-skeleton-loader>
  </template>
  <template v-else>
    <v-container class="pa-1" fluid>
      <v-row>
        <v-col class="pa-2" v-for="category in categoriesStore.categories" v-bind:key="category.id" cols="12" sm="6"
               md="3" xl="2">
          <CategoryCard :category="category" :on-delete="openDeleteDialog"></CategoryCard>
        </v-col>
      </v-row>
    </v-container>

    <ConfirmationModal :is-open="isDeleting" :on-canceled="closeDeleteDialog" :on-confirmed="confirmDelete">
      <template v-slot:title>{{ $t("resource.category.deletion.title") }}</template>
      <template v-slot:subtitle>{{ $t("resource.category.deletion.subtitle") }}</template>
      <template v-slot:content>
        <p>
          <b>{{ $t("resource.category.attributes.id") }}:</b>
          <i>{{ deletingCategory.id }}</i>
        </p>
        <p>
          <b>{{ $t("resource.category.attributes.key") }}:</b>
          <i>{{ deletingCategory.attributes.key }}</i>
        </p>
        <p>
          <b>{{ $t("resource.category.attributes.color") }}:</b>
          <i>{{ deletingCategory.attributes.color }}</i>
        </p>
        <p>
          <b>{{ $t("resource.category.attributes.icon") }}:</b>
          <v-icon aria-hidden="false">{{ deletingCategory.attributes.icon }}</v-icon>
        </p>
      </template>
    </ConfirmationModal>
  </template>
</template>


<script lang="ts">
import {useAppStore} from "@/stores/app";
import {useCategoriesStore} from "@/stores/categories";
import CategoryCard from "@/components/CategoryCard.vue";
import ConfirmationModal from "@/components/ConfirmationModal.vue";
import {Category} from "@/api/resources/categories";
import api from "@/api";
import {getTypeTranslationKey} from "../../services/types";
import {getCategoryTranslationKey} from "../../services/categories";

export default {
  setup() {
    const categoriesStore = useCategoriesStore();
    const appStore = useAppStore()

    return {categoriesStore, appStore};
  },
  data() {
    return {
      // Delete Line
      isDeleting: false,
      deletingCategory: {} as Category
    };
  },
  mounted() {
    if (this.categoriesStore.categories.length <= 0) {
      this.categoriesStore.fetchAll()
    }
  },
  computed: {},
  methods: {
    getCategoryTranslationKey,
    getTypeTranslationKey,
    openDeleteDialog(cat: Category) {
      this.deletingCategory = cat
      this.isDeleting = true
    },
    closeDeleteDialog() {
      this.isDeleting = false
    },
    async confirmDelete() {
      await api.categories
        .deleteOne(this.deletingCategory)
        .then(() => this.refreshCategories())
        .finally(() => this.isDeleting = false);
    },
    refreshCategories() {
      this.categoriesStore.fetchAll()
    }
  },
  components: {ConfirmationModal, CategoryCard},
};
</script>
