<template>
  <vue-apex-charts
    type="donut"
    :options="chartOptions"
    :series="chartSeries"
  ></vue-apex-charts>
</template>

<script lang="ts">
import VueApexCharts from "vue3-apexcharts";
import {getCategoryTranslationKey, getCategoryColor, knownCategories} from "@/services/categories";
import {useOperationsStore} from "@/stores/operations";

export default {
  setup() {
    const operationsStore = useOperationsStore()

    return {operationsStore}
  },
  data() {
    return {
      categories: knownCategories.filter((cat: string) => cat !== "salary")
    };
  },
  computed: {
    chartOptions() {
      return {
        chart: {
          type: 'donut',
        },
        dataLabels: {
          enabled: true,
          formatter: function (val: number) {
            return `${val.toFixed(0)}%`
          },
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
            formatter: function(value: number): string {
              return `${value.toFixed(2)} €`
            }
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
    colors(): string[] {
      return this.categories.map((cat: string) => getCategoryColor(cat))
    },
    labels(): string[] {
      return this.categories.map((cat: string) => this.$t(getCategoryTranslationKey(cat)))
    },
    chartSeries(): number[] {
      const series = this.categories.map((cat: string) => {
        const sum = this.operationsStore.all
          .filter((l) => l.attributes.category === cat)
          .reduce((sum, op) => sum + op.attributes.amount, 0)

        return Math.abs(sum)
      })

      return (series.every((s: number) => s === 0)) ? [] : series
    },
  },
  methods: {},
  components: {VueApexCharts},
};
</script>
