<script setup>
import {
  computed,
  onMounted,
  ref,
  watch
} from 'vue'

import {
  ElMessage,
  ElMessageBox
} from 'element-plus'

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

  const searchTerm = filters.value.search
    .trim()
    .toLowerCase()

  if (searchTerm) {
    list = list.filter((item) => {
      const category = String(item.category || '').toLowerCase()
      const remark = String(item.remark || '').toLowerCase()
      const date = String(item.date || '').toLowerCase()

      return (
        category.includes(searchTerm) ||
        remark.includes(searchTerm) ||
        date.includes(searchTerm)
      )
    })
  }

  if (
    filters.value.category &&
    filters.value.category !== 'All'
  ) {
    list = list.filter(
      (item) => item.category === filters.value.category
    )
  }

  list.sort((first, second) => {
    if (filters.value.sort === 'newest') {
      return new Date(second.date) - new Date(first.date)
    }

    if (filters.value.sort === 'oldest') {
      return new Date(first.date) - new Date(second.date)
    }

    if (filters.value.sort === 'highest') {
      return Number(second.amount) - Number(first.amount)
    }

    if (filters.value.sort === 'lowest') {
      return Number(first.amount) - Number(second.amount)
    }

    return 0
  })

  return list
})

async function loadExpenses() {
  try {
    await expensesStore.fetchExpenses()
  } catch {
    ElMessage.error(
      expensesStore.error || 'Unable to load expense records.'
    )
  }
}

function onFilterChange(payload) {
  filters.value = payload
}

function onEditExpense(expense) {
  expensesStore.selectExpense(expense)
  showEditModal.value = true
}

async function onDeleteExpense(id) {
  try {
    await ElMessageBox.confirm(
      'Are you sure you want to delete this expense?',
      'Delete expense',
      {
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }
    )

    await expensesStore.deleteExpense(id)

    ElMessage.success('Expense deleted.')
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      ElMessage.error(
        expensesStore.error || 'Unable to delete the expense.'
      )
    }
  }
}

watch(showEditModal, (value) => {
  if (!value) {
    expensesStore.clearSelectedExpense()
  }
})

onMounted(() => {
  loadExpenses()
})
</script>

<template>
  <div class="expenses-page">
    <div class="page-header">
      <div>
        <h1>Expenses</h1>
        <p>Track and manage every outgoing payment</p>
      </div>

      <el-button
        :loading="expensesStore.loading"
        @click="loadExpenses"
      >
        Refresh
      </el-button>
    </div>

    <el-alert
      v-if="expensesStore.error"
      :title="expensesStore.error"
      type="error"
      show-icon
      :closable="false"
    />

    <ExpenseFilters
      @filter-change="onFilterChange"
      @add-expense="showAddModal = true"
    />

    <div v-loading="expensesStore.loading">
      <ExpenseTable
        :expenses="filteredExpenses"
        @edit="onEditExpense"
        @delete="onDeleteExpense"
      />
    </div>

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
  margin: 0 0 6px;
  color: #111827;
  font-size: 32px;
  font-weight: 700;
}

.page-header p {
  margin: 0;
  color: #64748b;
  font-size: 14px;
}
</style>