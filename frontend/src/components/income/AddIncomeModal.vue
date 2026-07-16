<script setup>
import { reactive, watch } from 'vue'
import { ElMessage } from 'element-plus'

import { useIncomeStore } from '@/stores/income'
import {
  INCOME_CATEGORIES
} from '@/constants/categories'

const visible = defineModel()
const incomeStore = useIncomeStore()

const form = reactive({
  category: '',
  amount: null,
  date: '',
  remark: ''
})

function resetForm() {
  form.category = ''
  form.amount = null
  form.date = ''
  form.remark = ''
}

function validateForm() {
  if (!form.category) {
    ElMessage.warning(
      'Please select an income category.'
    )

    return false
  }

  if (
    form.amount === null ||
    Number(form.amount) <= 0
  ) {
    ElMessage.warning(
      'Amount must be greater than zero.'
    )

    return false
  }

  if (!form.date) {
    ElMessage.warning(
      'Please select an income date.'
    )

    return false
  }

  return true
}

async function saveIncome() {
  if (!validateForm()) {
    return
  }

  try {
    await incomeStore.addIncome({
      category: form.category,
      amount: Number(form.amount),
      date: form.date,
      remark: form.remark
    })

    ElMessage.success(
      'Income record added.'
    )

    resetForm()
    visible.value = false
  } catch {
    ElMessage.error(
      incomeStore.error ||
        'Unable to add the income record.'
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
    title="Add Income"
    width="500px"
    :close-on-click-modal="!incomeStore.loading"
    :close-on-press-escape="!incomeStore.loading"
  >
    <el-form label-position="top">
      <el-form-item
        label="Category"
        required
      >
        <el-select
          v-model="form.category"
          placeholder="Select category"
          style="width: 100%"
        >
          <el-option
            v-for="item in INCOME_CATEGORIES"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </el-form-item>

      <el-form-item
        label="Amount"
        required
      >
        <el-input-number
          v-model="form.amount"
          :min="0.01"
          :step="0.01"
          :precision="2"
          style="width: 100%"
        />
      </el-form-item>

      <el-form-item
        label="Date"
        required
      >
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
        :disabled="incomeStore.loading"
        @click="visible = false"
      >
        Cancel
      </el-button>

      <el-button
        type="primary"
        :loading="incomeStore.loading"
        @click="saveIncome"
      >
        Save
      </el-button>
    </template>
  </el-dialog>
</template>