<script setup lang="ts">
interface Props {
  value: number;
  maxValue: number;
  color: string;
  label: string;
}

withDefaults(defineProps<Props>(), {});
</script>

<template>
  <vue-apex-charts
    type="radialBar"
    :options="chartOptions"
    :series="calculateSeries"
  ></vue-apex-charts>
</template>

<script lang="ts">
import VueApexCharts from "vue3-apexcharts";

export default {
  data() {
    return {};
  },
  computed: {
    chartOptions() {
      return {
        chart: {
          type: "radialBar",
          offsetY: -10,
          animations: {
            enabled: true,
            easing: "linear",
          },
        },
        plotOptions: {
          radialBar: {
            startAngle: -135,
            endAngle: 135,
            dataLabels: {
              name: {
                fontSize: "14px",
                color: this.$props.color,
              },
              value: {
                color: undefined,
                formatter: () => `${this.percentageValue.toFixed(2)} %`,
              },
            },
          },
        },
        fill: {
          colors: [this.$props.color],
        },
        stroke: {
          dashArray: 4,
        },
        labels: [this.$props.label],
      };
    },
    calculateSeries(): number[] {
      return [(this.percentageValue > 100) ? 100 : this.percentageValue]
    },
    percentageValue(): number {
      return (this.$props.value * 100) / this.$props.maxValue;
    }
  },
  methods: {},
  components: { VueApexCharts },
};
</script>
