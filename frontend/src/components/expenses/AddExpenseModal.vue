<script setup>
import { reactive, watch } from 'vue'
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
  'Entertainment',
  'Health',
  'Other'
]

function resetForm() {
  form.category = ''
  form.amount = null
  form.date = ''
  form.remark = ''
}

watch(visible, (value) => {
  if (!value) {
    resetForm()
  }
})

function saveExpense() {
  if (!form.category || !form.date || form.amount === null || form.amount <= 0) {
    return
  }

  expensesStore.addExpense({
    category: form.category,
    amount: form.amount,
    date: form.date,
    remark: form.remark || '',
    type: 'EXPENSE'
  })

  resetForm()
  visible.value = false
}
</script>

<template>

<el-dialog
  v-model="visible"
  title="Add Expense"
  width="500"
>

  <el-form
    label-position="top"
  >

    <el-form-item label="Category">

      <el-select
        v-model="form.category"
        placeholder="Select category"
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
        placeholder="Select date"
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
      @click="saveExpense"
    >
      Save
    </el-button>

  </template>

</el-dialog>

</template>