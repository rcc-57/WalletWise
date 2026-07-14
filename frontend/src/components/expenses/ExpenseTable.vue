<script setup>

import ExpenseRow from './ExpenseRow.vue'

defineProps({

  expenses: {
    type: Array,
    required: true
  }

})

</script>

<template>

<div class="table-container">

  <table>

    <thead>

      <tr>

        <th>Date</th>

        <th>Category</th>

        <th>Amount</th>

        <th>Remark</th>

        <th>Actions</th>

      </tr>

    </thead>

    <tbody>

      <ExpenseRow
        v-for="expense in expenses"
        :key="expense.id"
        :expense="expense"
      />

    </tbody>

  </table>

</div>

</template>

<style scoped>

.table-container{

background:white;

border-radius:20px;

padding:24px;

box-shadow:0 10px 25px rgba(0,0,0,.05);

overflow-x:auto;

}

table{

width:100%;

border-collapse:collapse;

}

thead{

background:#f8fafc;

}

th{

padding:16px;

text-align:left;

font-size:14px;

font-weight:600;

color:#64748b;

}

</style>