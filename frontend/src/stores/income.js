import { defineStore } from 'pinia'
import { ref } from 'vue'
import { income as mockIncome } from '@/data/incomeData'

export const useIncomeStore = defineStore('income', () => {
  const income = ref([...mockIncome])
  const selectedIncome = ref(null)
  const isEditDialogOpen = ref(false)

  function addIncome(record) {
    income.value.unshift({
      id: Date.now(),
      ...record
    })
  }

  function deleteIncome(id) {
    income.value = income.value.filter((item) => item.id !== id)
  }

  function updateIncome(updatedRecord) {
    const index = income.value.findIndex((item) => item.id === updatedRecord.id)
    if (index !== -1) {
      income.value[index] = updatedRecord
    }
  }

  function selectIncome(record) {
    selectedIncome.value = { ...record }
    isEditDialogOpen.value = true
  }

  return {
    income,
    selectedIncome,
    isEditDialogOpen,
    addIncome,
    deleteIncome,
    updateIncome,
    selectIncome
  }
})
