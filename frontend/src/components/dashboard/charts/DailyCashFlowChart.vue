<script setup>
import { computed } from 'vue'

import {
  formatMoney
} from '@/utils/currency'

const props = defineProps({
  data: {
    type: Object,
    required: true
  },

  currency: {
    type: String,
    default: ''
  }
})

const chartOption = computed(() => {
  const labels =
    props.data?.labels || []

  const income =
    props.data?.income || []

  const expenses =
    props.data?.expenses || []

  return {
    tooltip: {
      trigger: 'axis',

      formatter(parameters) {
        if (
          !parameters ||
          parameters.length === 0
        ) {
          return ''
        }

        const lines = [
          `Day ${parameters[0].axisValue}`
        ]

        parameters.forEach((item) => {
          lines.push(
            `${item.marker}` +
            `${item.seriesName}: ` +
            `${formatMoney(
              item.value,
              props.currency
            )}`
          )
        })

        return lines.join('<br />')
      }
    },

    legend: {
      bottom: 0,
      data: [
        'Income',
        'Expenses'
      ]
    },

    grid: {
      left: 20,
      right: 20,
      top: 30,
      bottom: 55,
      containLabel: true
    },

    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: labels,
      name: 'Day'
    },

    yAxis: {
      type: 'value',
      min: 0
    },

    series: [
      {
        name: 'Income',
        type: 'line',
        smooth: true,
        symbolSize: 7,
        data: income,

        lineStyle: {
          width: 3,
          color: '#16a34a'
        },

        itemStyle: {
          color: '#16a34a'
        },

        areaStyle: {
          color: 'rgba(22, 163, 74, 0.10)'
        }
      },
      {
        name: 'Expenses',
        type: 'line',
        smooth: true,
        symbolSize: 7,
        data: expenses,

        lineStyle: {
          width: 3,
          color: '#ef4444'
        },

        itemStyle: {
          color: '#ef4444'
        },

        areaStyle: {
          color: 'rgba(239, 68, 68, 0.10)'
        }
      }
    ]
  }
})
</script>

<template>
  <v-chart
    class="chart"
    :option="chartOption"
    autoresize
  />
</template>

<style scoped>
.chart {
  width: 100%;
  height: 330px;
}
</style>