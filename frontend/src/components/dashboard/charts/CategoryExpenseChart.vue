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

  const values =
    props.data?.values || []

  const chartData = labels.map(
    (label, index) => ({
      name: label,
      value: Number(
        values[index] || 0
      )
    })
  )

  return {
    tooltip: {
      trigger: 'item',

      formatter(parameters) {
        const amount = formatMoney(
          parameters.value,
          props.currency
        )

        return (
          `${parameters.name}<br />` +
          `${amount} ` +
          `(${parameters.percent}%)`
        )
      }
    },

    legend: {
      orient: 'vertical',
      right: 10,
      top: 'center'
    },

    series: [
      {
        name: 'Expenses',
        type: 'pie',
        radius: [
          '45%',
          '72%'
        ],
        center: [
          '40%',
          '50%'
        ],
        avoidLabelOverlap: true,

        itemStyle: {
          borderRadius: 8,
          borderColor: '#ffffff',
          borderWidth: 2
        },

        label: {
          show: false
        },

        emphasis: {
          label: {
            show: true,
            fontSize: 14,
            fontWeight: 'bold'
          }
        },

        data: chartData
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