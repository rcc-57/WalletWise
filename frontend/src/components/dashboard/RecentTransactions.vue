<script setup>

defineProps({

  transactions:{
    type:Array,
    required:true
  }

})


</script>


<template>

<div class="transactions">


<div class="header">

<h2>
Recent Transactions
</h2>


<a>
View all
</a>


</div>



<table>


<thead>

<tr>

<th>
Date
</th>

<th>
Description
</th>

<th>
Category
</th>

<th>
Amount
</th>

</tr>

</thead>



<tbody>


<tr
v-for="item in transactions"
:key="item.date + item.description"
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

.transactions{

background:white;

border-radius:20px;

padding:30px;

}


.header{

display:flex;

justify-content:space-between;

align-items:center;

margin-bottom:25px;

}


.header h2{

font-size:26px;

}



.header a{

color:#2563eb;

cursor:pointer;

}



table{

width:100%;

border-collapse:collapse;

}



th{

text-align:left;

padding:15px;

color:#64748b;

}



td{

padding:15px;

border-top:1px solid #eee;

}



.income{

color:#22c55e;

}



.expense{

color:#ef4444;

}


</style>