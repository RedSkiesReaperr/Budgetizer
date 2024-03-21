<template>
  <template v-if="categoriesStore.fetching">
    <v-skeleton-loader :elevation="0" type="card"></v-skeleton-loader>
  </template>
  <template v-else>
    <v-row justify="center">
      <v-col cols="12" xs="12" sm="6" md="4" lg="3" xl="2" xxl="1">
        <v-btn class="w-100" color="#27ae60" prepend-icon="mdi-plus" rounded="lg" @click="openCreateDialog">
          {{ $t("resource.category.creation.action") }}
        </v-btn>
      </v-col>
    </v-row>

    <v-row>
      <v-col
        cols="12" xs="12" sm="6" md="4" lg="3" xl="2" xxl="2"
        v-for="category in categoriesStore.categories"
        v-bind:key="category.id">
        <CategoryCard :category="category" @delete="openDeleteDialog(category)"
                      @edit="openEditDialog(category)"></CategoryCard>
      </v-col>
    </v-row>

    <ConfirmationModal :is-open="isDeleting" :loading="deleteLoading" @cancel="closeDeleteDialog"
                       @confirm="confirmDelete">
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

    <ConfirmationModal :is-open="isCreating" :loading="createLoading" @cancel="closeCreateDialog"
                       @confirm="confirmCreate">
      <template v-slot:title>{{ $t("resource.category.creation.title") }}</template>
      <template v-slot:content>
        <v-container>
          <CategoryForm
            ref="categoryFormCreate"
            :mode="CategoryFormMode.CREATE"
            :target="creatingCategory"
            @submit="createSubmitting"
            @success="createSucceed"
            @fail="(err: any) => createFailed()"
            @finish="createSubmitted"/>
        </v-container>
      </template>
    </ConfirmationModal>

    <ConfirmationModal :is-open="isEditing" :loading="editLoading" @cancel="closeEditDialog" @confirm="confirmEdit">
      <template v-slot:title>{{ $t("resource.category.edition.title") }}</template>
      <template v-slot:content>
        <v-container>
          <CategoryForm
            ref="categoryFormEdit"
            :mode="CategoryFormMode.EDIT"
            :target="editingCategory"
            @submit="editSubmitting"
            @success="editSucceed"
            @fail="(err: any) => editFailed()"
            @finish="editSubmitted"/>
        </v-container>
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
      deleteLoading: false,
      deletingCategory: {} as Category,
      // Create Category
      isCreating: false,
      createLoading: false,
      creatingCategory: {} as Category,
      // Edit Category
      isEditing: false,
      editLoading: false,
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
      this.deleteLoading = false
      this.refreshCategories()
    },
    closeDeleteDialog() {
      this.isDeleting = false
      this.deleteLoading = false
    },
    async confirmDelete() {
      this.deleteLoading = true
      await api.categories
        .deleteOne(this.deletingCategory)
        .then(() => this.categoryDeleted())
        .finally(() => this.closeDeleteDialog());
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
      this.createLoading = true
    },
    createSucceed() {
      this.alertStore.show(AlertType.Success, this.$t('resource.category.creation.success_title'), this.$t('resource.category.creation.success_message'))
      this.isCreating = false
    },
    createFailed() {
      this.alertStore.show(AlertType.Error, this.$t('resource.category.creation.error'), '')
    },
    createSubmitted() {
      this.createLoading = false
      this.refreshCategories()
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
      this.editLoading = true
    },
    editSucceed() {
      this.alertStore.show(AlertType.Success, this.$t('resource.category.edition.success_title'), this.$t('resource.category.edition.success_message'))
      this.isEditing = false
    },
    editFailed() {
      this.alertStore.show(AlertType.Error, this.$t('resource.category.edition.error'), '')
    },
    editSubmitted() {
      this.editLoading = false
      this.refreshCategories()
    },
    refreshCategories() {
      this.categoriesStore.fetchAll()
    }
  },
  components: {Alert, ConfirmationModal, CategoryCard, CategoryForm},
};
</script>
