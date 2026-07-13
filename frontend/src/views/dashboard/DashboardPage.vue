<template>

  <div class="dashboard">

    <h1>
      Dashboard
    </h1>


    <!-- Cards -->

    <div class="cards">

      <BalanceCard />

      <IncomeCard />

      <ExpenseCard />

      <SavingsCard />

    </div>



    <!-- Charts placeholder -->

    <div class="charts">


      <div class="chart-box">

        <h2>
          Expenses Overview
        </h2>

        <p>
          Chart will be here
        </p>

      </div>



      <div class="chart-box">

        <h2>
          Expenses by Category
        </h2>

        <p>
          Chart will be here
        </p>

      </div>


    </div>




    <!-- Transactions -->

    <div class="transactions">


      <h2>
        Recent Transactions
      </h2>


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

          <tr>

            <td>
              Jul 13, 2026
            </td>

            <td>
              Grocery Shopping
            </td>

            <td>
              Food
            </td>

            <td class="expense">
              -$75.50
            </td>

          </tr>



          <tr>

            <td>
              Jul 12, 2026
            </td>

            <td>
              Salary
            </td>

            <td>
              Income
            </td>

            <td class="income">
              +$2500
            </td>

          </tr>


        </tbody>


      </table>


    </div>


  </div>


</template>



<script setup>


import BalanceCard from '@/components/dashboard/BalanceCard.vue'

import IncomeCard from '@/components/dashboard/IncomeCard.vue'

import ExpenseCard from '@/components/dashboard/ExpenseCard.vue'

import SavingsCard from '@/components/dashboard/SavingsCard.vue'


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