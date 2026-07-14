<script setup>
import { reactive, watch } from 'vue'
import { useExpensesStore } from '@/stores/expenses'

const visible = defineModel()
const expensesStore = useExpensesStore()

const form = reactive({
  id: null,
  category: '',
  amount: null,
  date: '',
  remark: '',
  type: 'EXPENSE'
})

const categories = [
  'Food',
  'Transport',
  'Shopping',
  'Entertainment',
  'Health',
  'Other'
]

watch(
  () => expensesStore.selectedExpense,
  (expense) => {
    if (expense) {
      form.id = expense.id
      form.category = expense.category
      form.amount = expense.amount
      form.date = expense.date
      form.remark = expense.remark
      form.type = expense.type || 'EXPENSE'
    } else {
      form.id = null
      form.category = ''
      form.amount = null
      form.date = ''
      form.remark = ''
      form.type = 'EXPENSE'
    }
  },
  { immediate: true }
)

watch(visible, (value) => {
  if (!value) {
    expensesStore.selectedExpense = null
  }
})

function updateExpense() {
  if (!form.id || !form.category || !form.date || form.amount === null || form.amount <= 0) {
    return
  }

  expensesStore.updateExpense({
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

<el-dialog
  v-model="visible"
  title="Edit Expense"
  width="500"
>

  <el-form label-position="top">

    <el-form-item label="Category">

      <el-select
        v-model="form.category"
      >

        <el-option
          v-for="item in categories"
          :key="item"
          :label="item"
          :value="item"
        />

      </el-select>

    </el-form-item>

    <el-form-item label="Amount">

      <el-input-number
        v-model="form.amount"
        :min="0"
        style="width:100%;"
      />

    </el-form-item>

    <el-form-item label="Date">

      <el-date-picker
        v-model="form.date"
        type="date"
        style="width:100%;"
      />

    </el-form-item>

    <el-form-item label="Remark">

      <el-input
        v-model="form.remark"
        type="textarea"
        :rows="3"
      />

    </el-form-item>

  </el-form>

  <template #footer>

    <el-button
      @click="visible = false"
    >
      Cancel
    </el-button>

    <el-button
      type="primary"
      @click="updateExpense"
    >
      Update
    </el-button>

  </template>

</el-dialog>

</template>