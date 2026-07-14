import { defineStore } from 'pinia'
import { ref } from 'vue'
import apiClient from '@/api/client'

export const useAnalyticsStore = defineStore('analytics', () => {
  const monthlyStats = ref(null)
  const loading = ref(false)
  const error = ref('')

  async function fetchMonthlyStatistics(year, month) {
    loading.value = true
    error.value = ''

    try {
      const params = {}
      if (year) params.year = year
      if (month) params.month = month

      const response = await apiClient.get('/api/statistics/monthly', { params })
      monthlyStats.value = response.data
      return response.data
    } catch (err) {
      error.value = err.response?.data?.message || 'Unable to load statistics.'
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    monthlyStats,
    loading,
    error,
    fetchMonthlyStatistics
  }
})
