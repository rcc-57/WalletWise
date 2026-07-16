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

function mapExpenseToApi(expense) {
  return {
    type: 'EXPENSE',
    category: expense.category
      .trim()
      .replace(/\s+/g, '_')
      .toUpperCase(),
    amount: Number(expense.amount),
    billDate: expense.date,
    remark: expense.remark?.trim() || null
  }
}

function getErrorMessage(error, fallbackMessage) {
  return error.response?.data?.message || fallbackMessage
}

export const useExpensesStore = defineStore('expenses', () => {
  const expenses = ref([])
  const selectedExpense = ref(null)
  const isEditDialogOpen = ref(false)

  const loading = ref(false)
  const error = ref('')

  async function fetchExpenses() {
    loading.value = true
    error.value = ''

    try {
      const bills = await getBills('EXPENSE')

      expenses.value = bills.map(mapBillFromApi)

      return expenses.value
    } catch (requestError) {
      error.value = getErrorMessage(
        requestError,
        'Unable to load expense records.'
      )

      throw requestError
    } finally {
      loading.value = false
    }
  }

  async function addExpense(expense) {
    loading.value = true
    error.value = ''

    try {
      const createdBill = await createBill(
        mapExpenseToApi(expense)
      )

      const createdExpense = mapBillFromApi(createdBill)

      expenses.value.unshift(createdExpense)

      return createdExpense
    } catch (requestError) {
      error.value = getErrorMessage(
        requestError,
        'Unable to add the expense record.'
      )

      throw requestError
    } finally {
      loading.value = false
    }
  }

  async function updateExpense(expense) {
    loading.value = true
    error.value = ''

    try {
      const updatedBill = await updateBill(
        expense.id,
        mapExpenseToApi(expense)
      )

      const updatedExpense = mapBillFromApi(updatedBill)

      const index = expenses.value.findIndex(
        (item) => item.id === updatedExpense.id
      )

      if (index !== -1) {
        expenses.value[index] = updatedExpense
      }

      selectedExpense.value = null
      isEditDialogOpen.value = false

      return updatedExpense
    } catch (requestError) {
      error.value = getErrorMessage(
        requestError,
        'Unable to update the expense record.'
      )

      throw requestError
    } finally {
      loading.value = false
    }
  }

  async function deleteExpense(id) {
    loading.value = true
    error.value = ''

    try {
      await deleteBill(id)

      expenses.value = expenses.value.filter(
        (expense) => expense.id !== id
      )
    } catch (requestError) {
      error.value = getErrorMessage(
        requestError,
        'Unable to delete the expense record.'
      )

      throw requestError
    } finally {
      loading.value = false
    }
  }

  function selectExpense(expense) {
    selectedExpense.value = {
      ...expense
    }

    isEditDialogOpen.value = true
  }

  function clearSelectedExpense() {
    selectedExpense.value = null
    isEditDialogOpen.value = false
  }

  return {
    expenses,
    selectedExpense,
    isEditDialogOpen,
    loading,
    error,
    fetchExpenses,
    addExpense,
    updateExpense,
    deleteExpense,
    selectExpense,
    clearSelectedExpense
  }
})