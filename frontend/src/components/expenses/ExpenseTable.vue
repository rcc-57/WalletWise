<script setup>
const props = defineProps({
  expenses: {
    type: Array,
    required: true
  }
})

const emit = defineEmits(['edit', 'delete'])

function editExpense(expense) {
  emit('edit', expense)
}

function deleteExpense(id) {
  emit('delete', id)
}
</script>

<template>
  <el-table
    :data="props.expenses"
    stripe
    border
    style="width: 100%"
  >
    <el-table-column prop="date" label="Date" width="140" />
    <el-table-column prop="category" label="Category" width="160" />
    <el-table-column prop="amount" label="Amount" width="140">
      <template #default="scope">
        <span class="amount">${{ scope.row.amount.toFixed(2) }}</span>
      </template>
    </el-table-column>
    <el-table-column prop="remark" label="Remark" />
    <el-table-column label="Actions" width="190">
      <template #default="scope">
        <el-button
          type="primary"
          size="small"
          @click="editExpense(scope.row)"
        >
          Edit
        </el-button>
        <el-button
          type="danger"
          size="small"
          @click="deleteExpense(scope.row.id)"
        >
          Delete
        </el-button>
      </template>
    </el-table-column>
  </el-table>
</template>

<style scoped>
.amount {
  font-weight: 700;
  color: #ef4444;
}
</style>