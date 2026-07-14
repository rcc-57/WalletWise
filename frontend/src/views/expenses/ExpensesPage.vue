<script setup>

import ExpenseTable from '@/components/expenses/ExpenseTable.vue'

import { expenses } from '@/data/expensesData'

</script>

<template>

<div class="expenses-page">

  <div class="page-header">

    <div>

      <h1>Expenses</h1>

      <p>Manage all your expense records</p>

    </div>

    <button class="add-button">

      + Add Expense

    </button>

  </div>

  <ExpenseTable
    :expenses="expenses"
  />

</div>

</template>

<style scoped>

.expenses-page{

display:flex;

flex-direction:column;

gap:24px;

}

.page-header{

display:flex;

justify-content:space-between;

align-items:center;

}

.page-header h1{

font-size:34px;

font-weight:700;

color:#111827;

margin-bottom:6px;

}

.page-header p{

color:#6b7280;

font-size:15px;

}

.add-button{

background:#2563eb;

color:white;

border:none;

padding:12px 20px;

border-radius:10px;

font-size:15px;

font-weight:600;

cursor:pointer;

transition:.2s;

}

.add-button:hover{

background:#1d4ed8;

}

</style>