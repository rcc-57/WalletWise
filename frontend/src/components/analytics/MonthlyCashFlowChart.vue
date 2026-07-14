<script setup>
import { onMounted, ref } from 'vue'
import Chart from 'chart.js/auto'

const props = defineProps({
  data: {
    type: Object,
    required: true
  }
})

const chart = ref(null)

onMounted(() => {
  new Chart(chart.value, {
    type: 'bar',
    data: {
      labels: props.data.labels,
      datasets: [
        {
          label: 'Income',
          data: props.data.income,
          backgroundColor: '#22c55e',
          borderRadius: 8
        },
        {
          label: 'Expenses',
          data: props.data.expenses,
          backgroundColor: '#ef4444',
          borderRadius: 8
        }
      ]
    },
    options: {
      responsive: true,
      plugins: {
        legend: {
          position: 'bottom'
        }
      },
      scales: {
        y: {
          beginAtZero: true
        }
      }
    }
  })
})
</script>

<template>
  <canvas ref="chart"></canvas>
</template>
