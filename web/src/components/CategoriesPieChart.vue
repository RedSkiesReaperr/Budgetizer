<script setup lang="ts">
import {Operation} from "@/api/resources/operations";

interface Props {
  operations: Operation[];
}

defineProps<Props>();
</script>

<template>
  <vue-apex-charts
    type="donut"
    :options="chartOptions"
    :series="chartSeries"
  ></vue-apex-charts>
</template>

<script lang="ts">
import VueApexCharts from "vue3-apexcharts";
import {
  getCategoryReadableKey,
  getCategoryTranslationKey,
  MISSING_CATEGORY,
  MISSING_CATEGORY_IDENTIFIER
} from "@/services/categories";
import {useCategoriesStore} from "@/stores/categories";
import {sum} from "@/services/calculations";
import {formatNumber} from "@/services/formatters";
import {Category} from "@/api/resources/categories";
import {getOperationsByCategory, getOperationsUncategorized} from "@/services/operations";

const categoriesStore = useCategoriesStore();

export default {
  computed: {
    chartOptions() {
      return {
        chart: {
          type: 'donut',
        },
        dataLabels: {
          enabled: true,
          formatter: (val: number) => `${val.toFixed(0)}%`,
          style: {
            fontSize: '12px'
          }
        },
        legend: {
          show: false
        },
        tooltip: {
          enabled: true,
          y: {
            formatter: (value: number) => `${formatNumber(value)} €`,
          }
        },
        noData: {
          text: this.$t('no_data'),
          align: 'center',
          verticalAlign: 'middle',
          offsetX: 0,
          offsetY: 0,
          style: {
            color: 'grey',
            fontSize: '15px',
            fontFamily: undefined
          }
        },
        colors: this.colors,
        labels: this.labels,
        responsive: [{
          breakpoint: 480,
          options: {
            chart: {
              width: 200
            },
            legend: {
              show: false
            }
          }
        }],
      }
    },
    categories(): Category[] {
      return [...categoriesStore.expenseCategories, MISSING_CATEGORY]
    },
    colors(): string[] {
      return this.categories.map((cat: Category) => cat.attributes.color)
    },
    labels(): string[] {
      return this.categories.map((cat: Category) => this.translatedLabel(cat))
    },
    chartSeries(): number[] {
      const series = this.categories.map((cat: Category) => {
        let ops = []

        if (cat.id === MISSING_CATEGORY_IDENTIFIER) {
          ops = getOperationsUncategorized(this.$props.operations)
        } else {
          ops = getOperationsByCategory(cat, this.$props.operations)
        }

        return Math.abs(sum(ops))
      })

      return (series.every((s: number) => s === 0)) ? [] : series
    },
  },
  methods: {
    translatedLabel(cat: Category): string {
      const translationKey = getCategoryTranslationKey(cat)

      if (this.$te(translationKey)) {
        return this.$t(translationKey);
      } else {
        return getCategoryReadableKey(cat)
      }
    }
  },
  components: {VueApexCharts},
};
</script>
