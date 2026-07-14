<script setup>
import { ref, computed, watch } from 'vue'
import ExpenseFilters from '@/components/expenses/ExpenseFilters.vue'
import ExpenseTable from '@/components/expenses/ExpenseTable.vue'
import AddExpenseModal from '@/components/expenses/AddExpenseModal.vue'
import EditExpenseModal from '@/components/expenses/EditExpenseModal.vue'
import { useExpensesStore } from '@/stores/expenses'

const expensesStore = useExpensesStore()
const showAddModal = ref(false)
const showEditModal = ref(false)

const filters = ref({
  search: '',
  category: 'All',
  sort: 'newest'
})

const filteredExpenses = computed(() => {
  let list = [...expensesStore.expenses]

  if (filters.value.search) {
    const term = filters.value.search.toLowerCase()
    list = list.filter(
      (item) =>
        item.category.toLowerCase().includes(term) ||
        item.remark.toLowerCase().includes(term) ||
        item.date.toLowerCase().includes(term)
    )
  }

  if (filters.value.category && filters.value.category !== 'All') {
    list = list.filter((item) => item.category === filters.value.category)
  }

  list.sort((a, b) => {
    if (filters.value.sort === 'newest') {
      return new Date(b.date) - new Date(a.date)
    }
    if (filters.value.sort === 'oldest') {
      return new Date(a.date) - new Date(b.date)
    }
    if (filters.value.sort === 'highest') {
      return b.amount - a.amount
    }
    if (filters.value.sort === 'lowest') {
      return a.amount - b.amount
    }
    return 0
  })

  return list
})

function onFilterChange(payload) {
  filters.value = payload
}

function onEditExpense(expense) {
  expensesStore.selectExpense(expense)
  showEditModal.value = true
}

function onDeleteExpense(id) {
  expensesStore.deleteExpense(id)
}

watch(showEditModal, (value) => {
  if (!value) {
    expensesStore.selectedExpense = null
    expensesStore.isEditDialogOpen = false
  }
})
</script>

<template>
  <div class="expenses-page">
    <div class="page-header">
      <div>
        <h1>Expenses</h1>
        <p>Track and manage every outgoing payment</p>
      </div>
    </div>

    <ExpenseFilters @filter-change="onFilterChange" @add-expense="showAddModal = true" />

    <ExpenseTable :expenses="filteredExpenses" @edit="onEditExpense" @delete="onDeleteExpense" />

    <AddExpenseModal v-model="showAddModal" />
    <EditExpenseModal v-model="showEditModal" />
  </div>
</template>

<style scoped>
.expenses-page {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-header h1 {
  font-size: 32px;
  font-weight: 700;
  color: #111827;
  margin-bottom: 6px;
}

.page-header p {
  font-size: 14px;
  color: #64748b;
}
</style>