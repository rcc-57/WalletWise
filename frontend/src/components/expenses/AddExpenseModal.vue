<script setup>
import { reactive, watch } from 'vue'
import { ElMessage } from 'element-plus'

import { useExpensesStore } from '@/stores/expenses'

const visible = defineModel()
const expensesStore = useExpensesStore()

const form = reactive({
  category: '',
  amount: null,
  date: '',
  remark: ''
})

const categories = [
  'Food',
  'Transport',
  'Shopping',
  'Housing',
  'Health',
  'Education',
  'Entertainment',
  'Other'
]

function resetForm() {
  form.category = ''
  form.amount = null
  form.date = ''
  form.remark = ''
}

function validateForm() {
  if (!form.category) {
    ElMessage.warning('Please select an expense category.')
    return false
  }

  if (
    form.amount === null ||
    Number(form.amount) <= 0
  ) {
    ElMessage.warning('Amount must be greater than zero.')
    return false
  }

  if (!form.date) {
    ElMessage.warning('Please select an expense date.')
    return false
  }

  return true
}

async function saveExpense() {
  if (!validateForm()) {
    return
  }

  try {
    await expensesStore.addExpense({
      category: form.category,
      amount: Number(form.amount),
      date: form.date,
      remark: form.remark
    })

    ElMessage.success('Expense added.')

    resetForm()
    visible.value = false
  } catch {
    ElMessage.error(
      expensesStore.error || 'Unable to add the expense.'
    )
  }
}

watch(visible, (value) => {
  if (!value) {
    resetForm()
  }
})
</script>

<template>
  <el-dialog
    v-model="visible"
    title="Add Expense"
    width="500px"
    :close-on-click-modal="!expensesStore.loading"
    :close-on-press-escape="!expensesStore.loading"
  >
    <el-form label-position="top">
      <el-form-item label="Category" required>
        <el-select
          v-model="form.category"
          placeholder="Select category"
          style="width: 100%"
        >
          <el-option
            v-for="item in categories"
            :key="item"
            :label="item"
            :value="item"
          />
        </el-select>
      </el-form-item>

      <el-form-item label="Amount" required>
        <el-input-number
          v-model="form.amount"
          :min="0.01"
          :step="0.01"
          :precision="2"
          style="width: 100%"
        />
      </el-form-item>

      <el-form-item label="Date" required>
        <el-date-picker
          v-model="form.date"
          type="date"
          value-format="YYYY-MM-DD"
          placeholder="Select date"
          style="width: 100%"
        />
      </el-form-item>

      <el-form-item label="Remark">
        <el-input
          v-model="form.remark"
          type="textarea"
          :rows="3"
          maxlength="255"
          show-word-limit
          placeholder="Optional description"
        />
      </el-form-item>
    </el-form>

    <template #footer>
      <el-button
        :disabled="expensesStore.loading"
        @click="visible = false"
      >
        Cancel
      </el-button>

      <el-button
        type="primary"
        :loading="expensesStore.loading"
        @click="saveExpense"
      >
        Save
      </el-button>
    </template>
  </el-dialog>
</template>