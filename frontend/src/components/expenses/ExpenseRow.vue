<script setup>

defineProps({

  expense: {
    type: Object,
    required: true
  }

})

</script>

<template>

<tr>

  <td>{{ expense.date }}</td>

  <td>

    <span class="category">
      {{ expense.category }}
    </span>

  </td>

  <td class="amount">

    ${{ expense.amount.toFixed(2) }}

  </td>

  <td>

    {{ expense.remark }}

  </td>

  <td>

    <button class="edit-btn">
      Edit
    </button>

    <button class="delete-btn">
      Delete
    </button>

  </td>

</tr>

</template>

<style scoped>

td{

padding:16px;

border-bottom:1px solid #e5e7eb;

font-size:15px;

vertical-align:middle;

}

.category{

background:#eef2ff;

color:#4338ca;

padding:6px 12px;

border-radius:999px;

font-size:13px;

font-weight:600;

}

.amount{

font-weight:700;

color:#ef4444;

}

.edit-btn{

background:#2563eb;

color:white;

border:none;

padding:8px 14px;

border-radius:8px;

cursor:pointer;

margin-right:8px;

transition:.2s;

}

.edit-btn:hover{

background:#1d4ed8;

}

.delete-btn{

background:#ef4444;

color:white;

border:none;

padding:8px 14px;

border-radius:8px;

cursor:pointer;

transition:.2s;

}

.delete-btn:hover{

background:#dc2626;

}

</style>