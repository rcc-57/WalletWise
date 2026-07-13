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


new Chart(chart.value,{


type:'doughnut',



data:{


labels:props.data.labels,


datasets:[

{


data:props.data.values,


backgroundColor:[

'#3b82f6',
'#22c55e',
'#f59e0b',
'#ef4444',
'#8b5cf6'

]


}

]


},



options:{


responsive:true,


plugins:{


legend:{


position:'right'


}


}


}



})


})



</script>




<template>


<canvas ref="chart"></canvas>


</template>