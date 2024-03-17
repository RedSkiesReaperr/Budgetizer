<template>
  <template v-if="categoriesStore.fetching">
    <v-skeleton-loader :elevation="0" type="card"></v-skeleton-loader>
  </template>
  <template v-else>
    <v-container class="mb-6 d-flex flex-row justify-center">
      <v-btn color="#27ae60" prepend-icon="mdi-plus" rounded="lg" @click="openCreateDialog">
        {{ $t("resource.category.creation.action") }}
      </v-btn>
    </v-container>
    <v-container class="pa-1" fluid>
      <v-row>
        <v-col class="pa-2" v-for="category in categoriesStore.categories" v-bind:key="category.id" cols="12" sm="6"
               md="3" xl="2">
          <CategoryCard :category="category" :on-delete="openDeleteDialog" :on-edit="openEditDialog"></CategoryCard>
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

    <ConfirmationModal :is-open="isCreating" :on-canceled="closeCreateDialog" :on-confirmed="confirmCreate">
      <template v-slot:title>{{ $t("resource.category.creation.title") }}</template>
      <template v-slot:content>
        <CategoryForm
          ref="categoryFormCreate"
          :mode="CategoryFormMode.CREATE"
          :on-submitting="createSubmitting"
          :on-submit-success="createSucceed"
          :on-submit-failed="createFailed"
          :on-submitted="createSubmitted"
          :target="creatingCategory"/>
      </template>
    </ConfirmationModal>

    <ConfirmationModal :is-open="isEditing" :on-canceled="closeEditDialog" :on-confirmed="confirmEdit">
      <template v-slot:title>{{ $t("resource.category.edition.title") }}</template>
      <template v-slot:content>
        <CategoryForm
          ref="categoryFormEdit"
          :mode="CategoryFormMode.EDIT"
          :on-submitting="editSubmitting"
          :on-submit-success="editSucceed"
          :on-submit-failed="editFailed"
          :on-submitted="editSubmitted"
          :target="editingCategory"/>
      </template>
    </ConfirmationModal>
  </template>
  <Alert></Alert>
</template>


<script lang="ts">
import {useAppStore} from "@/stores/app";
import {useCategoriesStore} from "@/stores/categories";
import CategoryCard from "@/components/CategoryCard.vue";
import CategoryForm, {CategoryFormMode} from "@/components/CategoryForm.vue";
import ConfirmationModal from "@/components/ConfirmationModal.vue";
import {Category} from "@/api/resources/categories";
import api from "@/api";
import {AlertType, useAlertStore} from "@/stores/alert";
import Alert from "@/components/Alert.vue";

export default {
  setup() {
    const categoriesStore = useCategoriesStore();
    const appStore = useAppStore()
    const alertStore = useAlertStore()

    return {categoriesStore, appStore, alertStore};
  },
  data() {
    return {
      // Delete Category
      isDeleting: false,
      deletingCategory: {} as Category,
      // Create Category
      isCreating: false,
      creatingCategory: {} as Category,
      // Edit Category
      isEditing: false,
      editingCategory: {} as Category
    };
  },
  mounted() {
    if (this.categoriesStore.categories.length <= 0) {
      this.categoriesStore.fetchAll()
    }
  },
  computed: {
    CategoryFormMode() {
      return CategoryFormMode
    }
  },
  methods: {
    // Category deletion actions
    openDeleteDialog(cat: Category) {
      this.deletingCategory = cat
      this.isDeleting = true
    },
    categoryDeleted() {
      this.alertStore.show(AlertType.Success, this.$t('resource.category.deletion.success_title'), this.$t('resource.category.deletion.success_message'))
      this.refreshCategories()
    },
    closeDeleteDialog() {
      this.isDeleting = false
    },
    async confirmDelete() {
      await api.categories
        .deleteOne(this.deletingCategory)
        .then(() => this.categoryDeleted())
        .finally(() => this.isDeleting = false);
    },
    // Category creation actions
    openCreateDialog() {
      this.creatingCategory = {attributes: {key: '', icon: '', color: ''}} as Category
      this.isCreating = true
      this.alertStore.hide()
    },
    closeCreateDialog() {
      this.isCreating = false
    },
    async confirmCreate() {
      (this.$refs.categoryFormCreate as any).$refs.form.$refs.form.requestSubmit()
    },
    createSubmitting() {
    },
    createSucceed() {
      this.alertStore.show(AlertType.Success, this.$t('resource.category.creation.success_title'), this.$t('resource.category.creation.success_message'))
      this.refreshCategories()
      this.isCreating = false
    },
    createFailed() {
      this.alertStore.show(AlertType.Error, this.$t('resource.category.creation.error'), '')
    },
    createSubmitted() {
    },
    // Category edition actions
    openEditDialog(cat: Category) {
      this.editingCategory = cat
      this.isEditing = true
      this.alertStore.hide()
    },
    closeEditDialog() {
      this.isEditing = false
    },
    confirmEdit() {
      (this.$refs.categoryFormEdit as any).$refs.form.$refs.form.requestSubmit()
    },
    editSubmitting() {
    },
    editSucceed() {
      this.alertStore.show(AlertType.Success, this.$t('resource.category.edition.success_title'), this.$t('resource.category.edition.success_message'))
      this.refreshCategories()
      this.isEditing = false
    },
    editFailed() {
      this.alertStore.show(AlertType.Error, this.$t('resource.category.edition.error'), '')
    },
    editSubmitted() {
    },
    refreshCategories() {
      this.categoriesStore.fetchAll()
    }
  },
  components: {Alert, ConfirmationModal, CategoryCard, CategoryForm},
};
</script>
