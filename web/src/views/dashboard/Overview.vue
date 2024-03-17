<template>
  <v-row>
    <v-col cols="12" xs="12" sm="6" md="4" lg="3" xl="2" xxl="2">
      <BasicCard class="h-100" :loading="false">
        <v-row>
          <v-col class="text-h6 text-center">
            {{ $t("operation.import.action") }}
          </v-col>
        </v-row>
        <v-row>
          <v-col class="text-center" align-self="center">
            <v-btn color="#27ae60" prepend-icon="mdi-cloud-upload-outline" rounded="lg" :loading="isSelecting"
                   @click="handleFileImport">
              {{ $t("actions.select_file") }}
            </v-btn>
          </v-col>
        </v-row>
        <input ref="uploader" class="d-none" type="file" accept=".csv" @change="onFileChanged">
      </BasicCard>
    </v-col>

    <v-col cols="12" xs="12" sm="6" md="4" lg="3" xl="2" xxl="2">
      <BasicCard class="px-0 py-0" :loading="operationsStore.fetching">
        <OperationsSparkLineChart :subtitle="$t('earning', 2)" :operations="operationsStore.incomes"
                                  :x-axis-labels="daysChartLabels" curve-color="#00b894"/>
      </BasicCard>
    </v-col>

    <v-col cols="12" xs="12" sm="6" md="4" lg="3" xl="2" xxl="2">
      <BasicCard class="px-0 py-0" :loading="operationsStore.fetching">
        <OperationsSparkLineChart :subtitle="$t('expense', 2)" :operations="operationsStore.expenses"
                                  :x-axis-labels="daysChartLabels" curve-color="#d63031"/>
      </BasicCard>
    </v-col>
  </v-row>

  <v-row>
    <v-col cols="12" xs="12" sm="6" md="4" lg="3" xl="2" xxl="2">
      <BasicCard :loading="operationsStore.fetching" :style="{ overflow: 'visible' }">
        <CategoriesPieChart/>
      </BasicCard>
    </v-col>
  </v-row>

  <v-row>
    <v-container>
      <v-divider></v-divider>
    </v-container>
  </v-row>

  <NotesSlider :notes="notesStore.notes" :loading="notesStore.fetching"></NotesSlider>
  <Alert></Alert>
</template>

<script lang="ts">
import BasicCard from "@/components/BasicCard.vue";
import NotesSlider from "@/components/NotesSlider.vue";
import {useOperationsStore} from "@/stores/operations";
import {useAppStore} from "@/stores/app";
import CategoriesPieChart from "@/components/CategoriesPieChart.vue";
import OperationsSparkLineChart from "@/components/OperationsSparkLineChart.vue";
import {daysInRangeAsStr} from "@/services/dates";
import api from "@/api";
import {AlertType, useAlertStore} from "@/stores/alert";
import {AxiosError} from "axios";
import {useNotesStore} from "@/stores/notes";
import Alert from "@/components/Alert.vue";
import {useCategoriesStore} from "@/stores/categories";

export default {
  setup() {
    const operationsStore = useOperationsStore()
    const appStore = useAppStore()
    const alertStore = useAlertStore()
    const notesStore = useNotesStore()
    const categoriesStore = useCategoriesStore()

    return {operationsStore, appStore, alertStore, notesStore, categoriesStore};
  },
  data() {
    return {
      isSelecting: false,
      selectedFile: null,
    }
  },
  mounted() {
    if (this.operationsStore.expenses.length <= 0) {
      this.operationsStore.fetchAll(this.appStore.currentDateStartAt, this.appStore.currentDateEndAt)
    }

    if (this.categoriesStore.categories.length <= 0) {
      this.categoriesStore.fetchAll()
    }

    if (this.notesStore.notes.length <= 0) {
      this.notesStore.fetchAll(this.appStore.currentDateStartAt)
    }
  },
  computed: {
    daysChartLabels(): string[] {
      return daysInRangeAsStr(this.appStore.currentDateStartAt, this.appStore.currentDateEndAt, "YYYY-MM-DD")
    },
  },
  methods: {
    handleFileImport() {
      this.isSelecting = true;

      window.addEventListener('focus', () => {
        this.isSelecting = false
      }, {once: true});

      (this.$refs.uploader as any).click();
    },
    onFileChanged(e: any) {
      this.selectedFile = e.target.files[0];

      api.operations.importFile(e.target.files[0])
        .then(() => {
          this.alertStore.show(AlertType.Success, this.$t("operation.import.success_title"), this.$t("operation.import.success_message"))
          this.operationsStore.fetchAll(this.appStore.currentDateStartAt, this.appStore.currentDateEndAt)
        })
        .catch((err: AxiosError<{ success: boolean, errors: string[] }>) => {
          const errors = err.response?.data.errors?.join('. ') || this.$t("something_went_wrong")

          this.alertStore.show(AlertType.Error, this.$t("operation.import.error_title"), errors)
        })
        .finally(() => {
          e.target.value = ''
        })
    },
  },
  components: {Alert, BasicCard, CategoriesPieChart, OperationsSparkLineChart, NotesSlider}
}
</script>
