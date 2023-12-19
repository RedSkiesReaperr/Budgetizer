<template>
  <div class="mb-8 d-flex flex-row flex-wrap" :style="{ gap: '18px' }">
    <BasicCard class="w-25 flex-grow-0" :loading="false">
      <div class="text-h6">{{ $t("operation.import.action") }}</div>
      <div class="h-75 d-flex flex-row flex-grow-1 align-center">
        <div class="d-flex flex-col flex-grow-1 justify-center">
          <v-btn color="#27ae60" prepend-icon="mdi-cloud-upload-outline" rounded="lg" :loading="isSelecting"
                 @click="handleFileImport">
            {{ $t("actions.select_file") }}
          </v-btn>
        </div>
      </div>
      <input ref="uploader" class="d-none" type="file" accept=".csv" @change="onFileChanged">
    </BasicCard>

    <BasicCard class="h-25 w-25 px-0 py-0 flex-grow-0" :loading="operationsStore.fetching">
      <OperationsSparkLineChart :subtitle="$t('earning', 2)" :operations="operationsStore.incomes"
                                :x-axis-labels="daysChartLabels" curve-color="#00b894"/>
    </BasicCard>
    <BasicCard class="h-25 w-25 px-0 py-0 flex-grow-0" :loading="operationsStore.fetching">
      <OperationsSparkLineChart :subtitle="$t('expense', 2)" :operations="operationsStore.expenses"
                                :x-axis-labels="daysChartLabels" curve-color="#d63031"/>
    </BasicCard>
    <BasicCard class="pb-4 w-25 flex-grow-0" :loading="operationsStore.fetching" :style="{ overflow: 'visible' }">
      <CategoriesPieChart/>
    </BasicCard>
  </div>
  <v-container><v-divider></v-divider></v-container>
  <NotesSlider :notes="notesStore.notes" :loading="notesStore.fetching"></NotesSlider>
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

export default {
  setup() {
    const operationsStore = useOperationsStore()
    const appStore = useAppStore()
    const alertStore = useAlertStore()
    const notesStore = useNotesStore()

    return {operationsStore, appStore, alertStore, notesStore};
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
  components: {BasicCard, CategoriesPieChart, OperationsSparkLineChart, NotesSlider}
}
</script>
