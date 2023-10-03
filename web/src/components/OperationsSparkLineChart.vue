<script setup lang="ts">
interface Props {
  subtitle: string;
  operations: Operation[];
  xAxisLabels: string[];
  curveColor?: string;
}

withDefaults(defineProps<Props>(), {
  curveColor: "#DCE6EC"
});
</script>

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
import moment from "moment";
import {Operation} from "@/api/resources/operations";

export default {
  computed: {
    dataAvailable(): boolean {
      return this.operationsSum > 0
    },
    chartOptions() {
      return {
        chart: {
          type: 'area',
          sparkline: {
            enabled: true,
          },
          animations: {
            enabled: true,
          },
        },
        labels: this.$props.xAxisLabels,
        yaxis: {
          show: false,
        },
        xaxis: {
          show: false,
          type: 'datetime',
        },
        colors: [this.$props.curveColor],
        title: {
          text: `${this.operationsSum.toFixed(2)}€`,
          offsetX: 30,
          offsetY: 20,
          style: {
            fontSize: '24px',
          }
        },
        subtitle: {
          text: this.$props.subtitle,
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
          },
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
      }
    },
    operationsSum(): number {
      return Math.abs(this.$props.operations.reduce((sum, op) => sum + op.attributes.amount, 0))
    },
    chartSeries() {
      const data: number[] = this.$props.xAxisLabels.map((value: string) => {
        return Math.abs(this.operationsAmountForDay(moment(value)))
      })

      return [{
        name: this.$props.subtitle,
        data: (this.dataAvailable) ? data : []
      }]
    },
  },
  methods: {
    operationsAmountForDay(day: moment.Moment): number {
      return this.$props.operations
        .filter((op: Operation) => moment(op.attributes.date).format("YYYY-MM-DD") === day.format("YYYY-MM-DD"))
        .reduce((sum, op) => sum + op.attributes.amount, 0)
    }
  },
  components: {VueApexCharts},
}
</script>
