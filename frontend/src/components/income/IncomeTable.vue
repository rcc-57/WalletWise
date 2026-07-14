<script setup>
const props = defineProps({
  income: {
    type: Array,
    required: true
  }
})

const emit = defineEmits(['edit', 'delete'])

function editIncome(item) {
  emit('edit', item)
}

function deleteIncome(id) {
  emit('delete', id)
}
</script>

<template>
  <el-table :data="props.income" stripe border style="width: 100%">
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
      </template>
    </el-table-column>
  </el-table>
</template>

<style scoped>
.amount {
  font-weight: 700;
  color: #10b981;
}
</style>
