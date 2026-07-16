import { defineStore } from 'pinia'
import { ref } from 'vue'

import apiClient from '@/api/client'

function normalizeStatistics(data) {
  return {
    month: data?.month || '',
    totalIncome: Number(data?.totalIncome || 0),
    totalExpense: Number(data?.totalExpense || 0),
    balance: Number(data?.balance || 0),
    expenseCategories: Array.isArray(data?.expenseCategories)
      ? data.expenseCategories.map((item) => ({
          category: item.category,
          amount: Number(item.amount || 0)
        }))
      : []
  }
}

function getErrorMessage(error) {
  return (
    error.response?.data?.message ||
    'Unable to load financial statistics.'
  )
}

export const useAnalyticsStore = defineStore(
  'analytics',
  () => {
    const monthlyStats = ref(null)
    const loading = ref(false)
    const error = ref('')

    async function fetchMonthlyStatistics(
      year = null,
      month = null
    ) {
      loading.value = true
      error.value = ''

      try {
        const params = {}

        if (year !== null && year !== undefined) {
          params.year = year
        }

        if (month !== null && month !== undefined) {
          params.month = month
        }

        const response = await apiClient.get(
          '/api/statistics/monthly',
          {
            params
          }
        )

        monthlyStats.value = normalizeStatistics(
          response.data
        )

        return monthlyStats.value
      } catch (requestError) {
        error.value = getErrorMessage(requestError)
        throw requestError
      } finally {
        loading.value = false
      }
    }

    function clearStatistics() {
      monthlyStats.value = null
      error.value = ''
    }

    return {
      monthlyStats,
      loading,
      error,
      fetchMonthlyStatistics,
      clearStatistics
    }
  }
)
