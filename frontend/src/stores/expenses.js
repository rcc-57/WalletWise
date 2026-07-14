import { defineStore } from 'pinia'
import { ref } from 'vue'

import { expenses as mockExpenses } from '@/data/expensesData'

export const useExpensesStore = defineStore('expenses', () => {

  const expenses = ref([...mockExpenses])
  const selectedExpense = ref(null)
  const isEditDialogOpen = ref(false)

  function addExpense(expense) {

    expenses.value.unshift({

      id: Date.now(),

      ...expense

    })

  }

  function deleteExpense(id) {

    expenses.value = expenses.value.filter(

      expense => expense.id !== id

    )

  }

  function updateExpense(updatedExpense) {

    const index = expenses.value.findIndex(

      expense => expense.id === updatedExpense.id

    )

    if (index !== -1) {

      expenses.value[index] = updatedExpense

    }

  }

  function selectExpense(expense) {

  selectedExpense.value = { ...expense }
  isEditDialogOpen.value = true

    }

  return {

  expenses,

  selectedExpense,

  isEditDialogOpen,

  addExpense,

  deleteExpense,

  updateExpense,

  selectExpense

}

})