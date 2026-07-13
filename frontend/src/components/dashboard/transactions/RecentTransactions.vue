<script setup>

defineProps({

  transactions:{
    type:Array,
    required:true
  }

})

</script>


<template>

<div class="transactions-card">


  <div class="header">

    <h2>
      Recent Transactions
    </h2>


    <button>
      View all
    </button>

  </div>



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


        <td
        :class="item.type"
        >
          {{ item.category }}
        </td>


        <td
        :class="item.type"
        >
          {{ item.amount }}
        </td>


      </tr>


    </tbody>


  </table>


</div>


</template>



<style scoped>


.transactions-card{

background:white;

border-radius:20px;

padding:30px;

box-shadow:
0 10px 30px rgba(0,0,0,0.05);

margin-top:30px;

}



.header{

display:flex;

justify-content:space-between;

align-items:center;

margin-bottom:25px;

}



.header h2{

font-size:24px;

font-weight:700;

}



button{

border:none;

background:none;

color:#2563eb;

font-weight:600;

cursor:pointer;

}



table{

width:100%;

border-collapse:collapse;

}



thead{

color:#64748b;

}



th{

text-align:left;

padding:15px 10px;

font-size:14px;

}



td{

padding:18px 10px;

border-top:1px solid #e5e7eb;

font-size:15px;

}



.income{

color:#16a34a;

}



.expense{

color:#ef4444;

}



</style>