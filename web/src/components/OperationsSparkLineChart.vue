<template>
  <vue-apex-charts
      type="area"
      :options="chartOptions"
      :series="chartSeries"
      height="100%"
  ></vue-apex-charts>
</template>

<script lang="ts">
import VueApexCharts from "vue3-apexcharts";
import {useOperationsStore} from "@/stores/operations";
import {useAppStore} from "@/stores/app";
import moment from "moment";
import {Operation} from "@/api/resources/operations";

export default {
  setup() {
    const operationsStore = useOperationsStore()
    const appStore = useAppStore()

    return {operationsStore, appStore}
  },
  computed: {
    dataAvailable(): boolean {
      return this.totalExpenses > 0
    },
    chartOptions() {
      return {
        chart: {
          type: 'area',
          sparkline: {
            enabled: true
          },
          animations: {
            enabled: true,
          },
        },
        fill: {
          opacity: 1,
        },
        labels: this.chartLabels,
        yaxis: {
          show: false,
          min: 0,
        },
        xaxis: {
          show: false,
          type: 'datetime',
        },
        colors: ['#DCE6EC'],
        title: {
          text: `${this.totalExpenses.toFixed(2)}€`,
          offsetX: 30,
          offsetY: 20,
          style: {
            fontSize: '24px',
          }
        },
        subtitle: {
          enabled: false,
          text: this.$t('expense', 2),
          offsetX: 30,
          offsetY: 50,
          style: {
            fontSize: '14px',
          },
        },
        tooltip: {
          enabled: true,
          y: {
            formatter: function (value: number): string {
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
    totalExpenses() {
      return Math.abs(this.operationsStore.totalExpenses)
    },
    chartLabels() {
      return this.appStore.currentDays.map((value) => value.format("YYYY-MM-DD"))
    },
    chartSeries() {
      const data: number[] = this.appStore.currentDays.map((value: moment.Moment) => {
        return Math.abs(this.expensesAmountForDay(value))
      })

      return [{
        name: this.$t('expense', 2),
        data: (this.dataAvailable) ? data : []
      }]
    },
  },
  methods: {
    expensesAmountForDay(day: moment.Moment): number {
      return this.operationsStore.expenses
          .filter((op: Operation) => moment(op.attributes.date).format("YYYY-MM-DD") === day.format("YYYY-MM-DD"))
          .reduce((sum, op) => sum + op.attributes.amount, 0)
    }
  },
  components: {VueApexCharts},
}
</script>
