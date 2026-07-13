<template>


<div class="chart-container">


<h2>
Expenses by Category
</h2>



<v-chart

class="chart"

:option="option"

autoresize

/>


</div>


</template>




<script setup>


import { computed } from 'vue'


import { use } from 'echarts/core'


import { CanvasRenderer } from 'echarts/renderers'


import { PieChart } from 'echarts/charts'


import {

TooltipComponent,

LegendComponent

} from 'echarts/components'


import VChart from 'vue-echarts'



use([

CanvasRenderer,

PieChart,

TooltipComponent,

LegendComponent

])




const props = defineProps({

data:{

type:Object,

required:true

}

})





const option = computed(() => ({


tooltip:{

trigger:"item"

},



legend:{

orient:"vertical",

right:0,

top:"center"

},



series:[


{

name:"Expenses",

type:"pie",


radius:[

"40%",

"70%"

],



data:props.data.labels.map(

(label,index)=>(

{

name:label,

value:props.data.values[index]

}

)

),


label:{

show:false

}



}


]


}))



</script>




<style scoped>


.chart-container{


background:white;

border-radius:20px;

padding:30px;

height:350px;


}



h2{

font-size:22px;

margin-bottom:20px;

}



.chart{


width:100%;

height:260px;


}



</style>