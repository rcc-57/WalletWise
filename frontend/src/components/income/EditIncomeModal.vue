<script setup>
import { reactive, watch } from 'vue'
import { useIncomeStore } from '@/stores/income'

const visible = defineModel()
const incomeStore = useIncomeStore()

const form = reactive({
  id: null,
  category: '',
  amount: null,
  date: '',
  remark: '',
  type: 'INCOME'
})

const categories = [
  'Salary',
  'Bonus',
  'Investment',
  'Other'
]

watch(
  () => incomeStore.selectedIncome,
  (income) => {
    if (income) {
      form.id = income.id
      form.category = income.category
      form.amount = income.amount
      form.date = income.date
      form.remark = income.remark
      form.type = income.type || 'INCOME'
    } else {
      form.id = null
      form.category = ''
      form.amount = null
      form.date = ''
      form.remark = ''
      form.type = 'INCOME'
    }
  },
  { immediate: true }
)

watch(visible, (value) => {
  if (!value) {
    incomeStore.selectedIncome = null
  }
})

function updateIncome() {
  if (!form.id || !form.category || !form.date || form.amount === null || form.amount <= 0) {
    return
  }

  incomeStore.updateIncome({
    id: form.id,
    category: form.category,
    amount: form.amount,
    date: form.date,
    remark: form.remark || '',
    type: form.type
  })

  visible.value = false
}
</script>

<template>
  <el-dialog v-model="visible" title="Edit Income" width="500">
    <el-form label-position="top">
      <el-form-item label="Category">
        <el-select v-model="form.category">
          <el-option
            v-for="item in categories"
            :key="item"
            :label="item"
            :value="item"
          />
        </el-select>
      </el-form-item>

      <el-form-item label="Amount">
        <el-input-number v-model="form.amount" :min="0" style="width: 100%;" />
      </el-form-item>

      <el-form-item label="Date">
        <el-date-picker v-model="form.date" type="date" style="width: 100%;" />
      </el-form-item>

      <el-form-item label="Remark">
        <el-input v-model="form.remark" type="textarea" :rows="3" />
      </el-form-item>
    </el-form>

    <template #footer>
      <el-button @click="visible = false">Cancel</el-button>
      <el-button type="primary" @click="updateIncome">Update</el-button>
    </template>
  </el-dialog>
</template>
