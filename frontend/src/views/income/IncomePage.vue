<script setup>
import { ref, computed, watch } from 'vue'
import IncomeFilters from '@/components/income/IncomeFilters.vue'
import IncomeTable from '@/components/income/IncomeTable.vue'
import AddIncomeModal from '@/components/income/AddIncomeModal.vue'
import EditIncomeModal from '@/components/income/EditIncomeModal.vue'
import { useIncomeStore } from '@/stores/income'

const incomeStore = useIncomeStore()
const showAddModal = ref(false)
const showEditModal = ref(false)

const filters = ref({
  search: '',
  category: 'All',
  sort: 'newest'
})

const filteredIncome = computed(() => {
  let list = [...incomeStore.income]

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

function onEditIncome(income) {
  incomeStore.selectIncome(income)
  showEditModal.value = true
}

function onDeleteIncome(id) {
  incomeStore.deleteIncome(id)
}

watch(showEditModal, (value) => {
  if (!value) {
    incomeStore.selectedIncome = null
    incomeStore.isEditDialogOpen = false
  }
})
</script>

<template>
  <div class="income-page">
    <div class="page-header">
      <div>
        <h1>Income</h1>
        <p>Manage all your income records</p>
      </div>
    </div>

    <IncomeFilters
      @filter-change="onFilterChange"
      @add-income="showAddModal = true"
    />

    <IncomeTable
      :income="filteredIncome"
      @edit="onEditIncome"
      @delete="onDeleteIncome"
    />

    <AddIncomeModal v-model="showAddModal" />
    <EditIncomeModal v-model="showEditModal" />
  </div>
</template>

<style scoped>
.income-page {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-header h1 {
  font-size: 34px;
  font-weight: 700;
  color: #111827;
  margin-bottom: 6px;
}

.page-header p {
  font-size: 15px;
  color: #6b7280;
}
</style>
