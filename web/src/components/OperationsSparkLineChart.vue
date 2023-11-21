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
import {operationsForDay} from "@/services/operations";
import {sum} from "@/services/calculations";
import { formatNumber } from "@/services/formatters";

export default {
  computed: {
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
          text: `${formatNumber(this.titleValue)}€`,
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
              return `${formatNumber(value)} €`
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
    dataAvailable(): boolean {
      return this.titleValue > 0
    },
    titleValue(): number {
      return Math.abs(sum(this.$props.operations))
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
      return sum(operationsForDay(this.$props.operations, day))
    }
  },
  components: {VueApexCharts},
}
</script>
