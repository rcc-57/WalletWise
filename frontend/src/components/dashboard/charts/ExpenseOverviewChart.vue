<script setup>

import { onMounted, ref } from 'vue'
import Chart from 'chart.js/auto'


const props = defineProps({

data:{
type:Object,
required:true
}

})


const chart = ref(null)



onMounted(()=>{


new Chart(chart.value, {


type:'bar',


data:{


labels: props.data.labels,


datasets:[

{

label:'Expenses',

data:props.data.values,


backgroundColor:'#3b82f6',

borderRadius:8

}

]


},



options:{


responsive:true,


plugins:{


legend:{


display:false


}


},



scales:{


y:{


beginAtZero:true


}


}


}



})


})


</script>



<template>


<canvas ref="chart"></canvas>


</template>