<script setup>

import {
  dashboardCards,
  expenseOverviewData,
  categoryExpenseData,
  transactions
} from '@/data/dashboardData'


import BalanceCard from '@/components/dashboard/cards/BalanceCard.vue'
import IncomeCard from '@/components/dashboard/cards/IncomeCard.vue'
import ExpenseCard from '@/components/dashboard/cards/ExpenseCard.vue'
import SavingsCard from '@/components/dashboard/cards/SavingsCard.vue'


import ExpenseOverviewChart from '@/components/dashboard/charts/ExpenseOverviewChart.vue'
import CategoryExpenseChart from '@/components/dashboard/charts/CategoryExpenseChart.vue'


import RecentTransactions from '@/components/dashboard/transactions/RecentTransactions.vue'

</script>



<template>

<div class="dashboard">


<h1>
Dashboard
</h1>



<div class="cards-grid">


<BalanceCard 
:data="dashboardCards[0]"
/>


<IncomeCard
:data="dashboardCards[1]"
/>


<ExpenseCard
:data="dashboardCards[2]"
/>


<SavingsCard
:data="dashboardCards[3]"
/>


</div>





<div class="charts-grid">


<div class="chart-box">


<h2>
Expenses Overview
</h2>


<ExpenseOverviewChart
:data="expenseOverviewData"
/>


</div>



<div class="chart-box">


<h2>
Expenses by Category
</h2>


<CategoryExpenseChart
:data="categoryExpenseData"
/>


</div>


</div>




<div class="transactions-box">


<RecentTransactions
:transactions="transactions"
/>


</div>



</div>

</template>





<style scoped>


.dashboard {

width:100%;

}



.dashboard h1 {

font-size:36px;

margin-bottom:35px;

color:#111827;

}





.cards-grid {


display:grid;

grid-template-columns:repeat(4,minmax(0,1fr));

gap:24px;

margin-bottom:35px;


}




.charts-grid {


display:grid;

grid-template-columns:repeat(2,1fr);

gap:24px;

margin-bottom:35px;


}



.chart-box,
.transactions-box {


background:white;

border-radius:20px;

padding:25px;

box-shadow:
0 10px 25px rgba(0,0,0,0.05);


}




.chart-box h2 {


margin-bottom:20px;

font-size:22px;


}



@media(max-width:1200px){


.cards-grid{

grid-template-columns:repeat(2,1fr);

}


}



@media(max-width:800px){


.cards-grid,
.charts-grid{

grid-template-columns:1fr;

}


}


</style>