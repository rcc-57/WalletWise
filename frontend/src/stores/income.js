import { defineStore } from 'pinia'
import { ref } from 'vue'

import {
  getBills,
  createBill,
  updateBill,
  deleteBill
} from '@/api/bills'

function formatCategory(category) {
  if (!category) {
    return ''
  }

  return category
    .toLowerCase()
    .replace(/_/g, ' ')
    .replace(/\b\w/g, (letter) => letter.toUpperCase())
}

function mapBillFromApi(bill) {
  return {
    id: bill.id,
    type: bill.type,
    category: formatCategory(bill.category),
    amount: Number(bill.amount),
    date: bill.billDate,
    remark: bill.remark || '',
    createdAt: bill.createdAt,
    updatedAt: bill.updatedAt
  }
}

function mapIncomeToApi(record) {
  return {
    type: 'INCOME',
    category: record.category
      .trim()
      .replace(/\s+/g, '_')
      .toUpperCase(),
    amount: Number(record.amount),
    billDate: record.date,
    remark: record.remark?.trim() || null
  }
}

function getErrorMessage(error, fallbackMessage) {
  return error.response?.data?.message || fallbackMessage
}

export const useIncomeStore = defineStore('income', () => {
  const income = ref([])
  const selectedIncome = ref(null)
  const isEditDialogOpen = ref(false)

  const loading = ref(false)
  const error = ref('')

  async function fetchIncome() {
    loading.value = true
    error.value = ''

    try {
      const bills = await getBills('INCOME')

      income.value = bills.map(mapBillFromApi)

      return income.value
    } catch (requestError) {
      error.value = getErrorMessage(
        requestError,
        'Unable to load income records.'
      )

      throw requestError
    } finally {
      loading.value = false
    }
  }

  async function addIncome(record) {
    loading.value = true
    error.value = ''

    try {
      const createdBill = await createBill(
        mapIncomeToApi(record)
      )

      const createdIncome = mapBillFromApi(createdBill)

      income.value.unshift(createdIncome)

      return createdIncome
    } catch (requestError) {
      error.value = getErrorMessage(
        requestError,
        'Unable to add the income record.'
      )

      throw requestError
    } finally {
      loading.value = false
    }
  }

  async function updateIncome(record) {
    loading.value = true
    error.value = ''

    try {
      const updatedBill = await updateBill(
        record.id,
        mapIncomeToApi(record)
      )

      const updatedIncome = mapBillFromApi(updatedBill)

      const index = income.value.findIndex(
        (item) => item.id === updatedIncome.id
      )

      if (index !== -1) {
        income.value[index] = updatedIncome
      }

      selectedIncome.value = null
      isEditDialogOpen.value = false

      return updatedIncome
    } catch (requestError) {
      error.value = getErrorMessage(
        requestError,
        'Unable to update the income record.'
      )

      throw requestError
    } finally {
      loading.value = false
    }
  }

  async function deleteIncomeRecord(id) {
    loading.value = true
    error.value = ''

    try {
      await deleteBill(id)

      income.value = income.value.filter(
        (item) => item.id !== id
      )
    } catch (requestError) {
      error.value = getErrorMessage(
        requestError,
        'Unable to delete the income record.'
      )

      throw requestError
    } finally {
      loading.value = false
    }
  }

  async function deleteIncome(id) {
    return deleteIncomeRecord(id)
  }

  function selectIncome(record) {
    selectedIncome.value = {
      ...record
    }

    isEditDialogOpen.value = true
  }

  function clearSelectedIncome() {
    selectedIncome.value = null
    isEditDialogOpen.value = false
  }

  return {
    income,
    selectedIncome,
    isEditDialogOpen,
    loading,
    error,
    fetchIncome,
    addIncome,
    updateIncome,
    deleteIncome,
    selectIncome,
    clearSelectedIncome
  }
})