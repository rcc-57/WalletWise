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
    type: 'line',
    data: {
      labels: props.data.labels,
      datasets: [
        {
          label: 'Net Balance',
          data: props.data.values,
          borderColor: '#3b82f6',
          backgroundColor: 'rgba(59, 130, 246, 0.1)',
          fill: true,
          tension: 0.3,
          pointRadius: 4,
          pointBackgroundColor: '#3b82f6'
        }
      ]
    },
    options: {
      responsive: true,
      plugins: {
        legend: {
          display: false
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
