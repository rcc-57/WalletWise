<template>

  <div class="dashboard">

    <h1>
      Dashboard
    </h1>


    <!-- Cards -->

    <div class="cards">

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



    <!-- Charts placeholder -->

    <div class="charts">


      <ExpenseOverviewChart
        :data="expensesOverviewData"
      />

      <CategoryExpenseChart
        :data="categoryExpenseData"
      />

      <RecentTransactions
        :transactions="transactions"
      />


    </div>


  </div>


</template>



<script setup>

import BalanceCard from '@/components/dashboard/cards/BalanceCard.vue'
import IncomeCard from '@/components/dashboard/cards/IncomeCard.vue'
import ExpenseCard from '@/components/dashboard/cards/ExpenseCard.vue'
import SavingsCard from '@/components/dashboard/cards/SavingsCard.vue'

import ExpenseOverviewChart from '@/components/dashboard/charts/ExpenseOverviewChart.vue'
import CategoryExpenseChart from '@/components/dashboard/charts/CategoryExpenseChart.vue'

import RecentTransactions from '@/components/dashboard/RecentTransactions.vue'

import {
 dashboardCards
} from '@/data/dashboardData'

import {
  transactions
} from '@/data/dashboardData'

import {

expensesOverviewData,

categoryExpenseData

} from '@/data/dashboardData'

</script>



<style scoped>


.dashboard {

width:100%;

}



h1 {

font-size:32px;

margin-bottom:30px;

}




.cards {


display:grid;

grid-template-columns:repeat(4,1fr);

gap:20px;


}





.charts {


display:grid;

grid-template-columns:1fr 1fr;

gap:20px;

margin-top:30px;


}



.chart-box {


background:white;

height:300px;

border-radius:16px;

padding:25px;


box-shadow:0 4px 20px rgba(0,0,0,0.05);


}




.transactions {


background:white;

margin-top:30px;

padding:25px;

border-radius:16px;


box-shadow:0 4px 20px rgba(0,0,0,0.05);


}



table {

width:100%;

border-collapse:collapse;

margin-top:20px;

}



th, td {


text-align:left;

padding:15px;

border-bottom:1px solid #e5e7eb;


}



.expense {

color:#ef4444;

}



.income {

color:#22c55e;

}



</style>