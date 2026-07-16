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

async function loadIncome() {
  try {
    await incomeStore.fetchIncome()
  } catch {
    ElMessage.error(
      incomeStore.error || 'Unable to load income records.'
    )
  }
}

function onFilterChange(payload) {
  filters.value = payload
}

function onEditIncome(income) {
  incomeStore.selectIncome(income)
  showEditModal.value = true
}

async function onDeleteIncome(id) {
  try {
    await ElMessageBox.confirm(
      'Are you sure you want to delete this income record?',
      'Delete income',
      {
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }
    )

    await incomeStore.deleteIncome(id)

    ElMessage.success('Income record deleted.')
  } catch (error) {
    if (error !== 'cancel' && error !== 'close') {
      ElMessage.error(
        incomeStore.error || 'Unable to delete the income record.'
      )
    }
  }
}

watch(showEditModal, (value) => {
  if (!value) {
    incomeStore.clearSelectedIncome()
  }
})

onMounted(() => {
  loadIncome()
})
</script>

<template>
  <div class="income-page">
    <div class="page-header">
      <div>
        <h1>Income</h1>
        <p>Track recurring and one-off earnings clearly</p>
      </div>

      <el-button
        :loading="incomeStore.loading"
        @click="loadIncome"
      >
        Refresh
      </el-button>
    </div>

    <el-alert
      v-if="incomeStore.error"
      :title="incomeStore.error"
      type="error"
      show-icon
      :closable="false"
    />

    <IncomeFilters
      @filter-change="onFilterChange"
      @add-income="showAddModal = true"
    />

    <div v-loading="incomeStore.loading">
      <IncomeTable
        :income="filteredIncome"
        @edit="onEditIncome"
        @delete="onDeleteIncome"
      />
    </div>

    <AddIncomeModal v-model="showAddModal" />
    <EditIncomeModal v-model="showEditModal" />
  </div>
</template>

<style scoped>
.income-page {
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