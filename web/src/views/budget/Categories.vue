<template>
  <template v-if="categoriesStore.fetching">
    <v-skeleton-loader :elevation="0" type="card"></v-skeleton-loader>
  </template>
  <template v-else>
    <v-container class="pa-1" fluid>
      <v-row>
        <v-col class="pa-2" v-for="category in categoriesStore.categories" v-bind:key="category.id" cols="12" sm="6" md="3" xl="2">
          <CategoryCard class=""  :category="category"></CategoryCard>
        </v-col>
      </v-row>
    </v-container>
  </template>
</template>


<script lang="ts">
import {useAppStore} from "@/stores/app";
import {useCategoriesStore} from "@/stores/categories";
import CategoryCard from "@/components/CategoryCard.vue";

export default {
  setup() {
    const categoriesStore = useCategoriesStore();
    const appStore = useAppStore()

    return {categoriesStore, appStore};
  },
  data() {
    return {};
  },
  mounted() {
    if (this.categoriesStore.categories.length <= 0) {
      this.categoriesStore.fetchAll()
    }
  },
  components: {CategoryCard},
};
</script>
