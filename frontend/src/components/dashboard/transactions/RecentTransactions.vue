<script setup>
defineProps({
  transactions: {
    type: Array,
    required: true
  }
})
</script>

<template>
  <div class="transactions-card">
    <div class="header">
      <div>
        <h2>Recent Transactions</h2>

        <p>
          Your five latest operations
        </p>
      </div>
    </div>

    <el-empty
      v-if="transactions.length === 0"
      description="No transactions yet"
    />

    <div
      v-else
      class="table-wrapper"
    >
      <table>
        <thead>
          <tr>
            <th>Date</th>
            <th>Description</th>
            <th>Category</th>
            <th>Amount</th>
          </tr>
        </thead>

        <tbody>
          <tr
            v-for="item in transactions"
            :key="item.id"
          >
            <td>
              {{ item.date }}
            </td>

            <td>
              {{ item.description }}
            </td>

            <td :class="item.type">
              {{ item.category }}
            </td>

            <td :class="item.type">
              {{ item.amount }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.transactions-card {
  margin-top: 30px;
  padding: 30px;
  border-radius: 20px;
  background: white;
  box-shadow: 0 10px 30px
    rgba(0, 0, 0, 0.05);
}

.header {
  margin-bottom: 25px;
}

.header h2 {
  margin: 0 0 5px;
  font-size: 24px;
  font-weight: 700;
}

.header p {
  margin: 0;
  color: #64748b;
  font-size: 13px;
}

.table-wrapper {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
}

thead {
  color: #64748b;
}

th {
  padding: 15px 10px;
  text-align: left;
  font-size: 14px;
}

td {
  padding: 18px 10px;
  border-top: 1px solid #e5e7eb;
  font-size: 15px;
}

.income {
  color: #16a34a;
  font-weight: 600;
}

.expense {
  color: #ef4444;
  font-weight: 600;
}
</style>