<script setup>
import { useAuthStore } from '@/stores/auth'

import {
  formatMoney
} from '@/utils/currency'

const props = defineProps({
  income: {
    type: Array,
    required: true
  }
})

const emit = defineEmits([
  'edit',
  'delete'
])

const authStore = useAuthStore()

function formatAmount(amount) {
  return formatMoney(
    amount,
    authStore.user?.currency
  )
}

function editIncome(item) {
  emit('edit', item)
}

function deleteIncome(id) {
  emit('delete', id)
}
</script>

<template>
  <div class="table-card">
    <el-table
      :data="props.income"
      stripe
      border
      style="width: 100%"
      class="custom-table"
      empty-text="No income records"
    >
      <el-table-column
        prop="date"
        label="Date"
        width="140"
      />

      <el-table-column
        prop="category"
        label="Category"
        width="160"
      />

      <el-table-column
        prop="amount"
        label="Amount"
        width="180"
      >
        <template #default="scope">
          <span class="amount">
            {{ formatAmount(scope.row.amount) }}
          </span>
        </template>
      </el-table-column>

      <el-table-column
        prop="remark"
        label="Remark"
      />

      <el-table-column
        label="Actions"
        width="200"
      >
        <template #default="scope">
          <div class="action-group">
            <el-button
              type="primary"
              size="small"
              @click="editIncome(scope.row)"
            >
              Edit
            </el-button>

            <el-button
              type="danger"
              size="small"
              @click="deleteIncome(scope.row.id)"
            >
              Delete
            </el-button>
          </div>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<style scoped>
.table-card {
  padding: 16px;
  border-radius: 18px;
  background: white;
  box-shadow: 0 10px 30px
    rgba(15, 23, 42, 0.06);
}

.custom-table
  :deep(.el-table__header-wrapper th) {
  background: #f8fafc;
  color: #475569;
}

.action-group {
  display: flex;
  gap: 8px;
}

.amount {
  color: #16a34a;
  font-weight: 700;
}
</style>