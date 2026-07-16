<script setup>

import BaseCard from './BaseCard.vue'


defineProps({

  data:{
    type:Object,
    required:true
  }

})


</script>


<template>

<BaseCard>

  <template #icon>
    💎
  </template>


  <template #title>
    {{ data.title }}
  </template>


  <template #value>
    {{ data.value }}
  </template>


  <template #change>
    {{ data.change }}
  </template>


</BaseCard>

</template>