<template>

  <div class="chart-container">

    <h2>
      Expenses Overview
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

import { BarChart } from 'echarts/charts'


import {

  GridComponent,
  TooltipComponent

} from 'echarts/components'


import VChart from 'vue-echarts'



use([

  CanvasRenderer,

  BarChart,

  GridComponent,

  TooltipComponent

])



const props = defineProps({

  data:{
    type:Object,
    required:true
  }

})



const option = computed(() => ({


  tooltip:{

    trigger:"axis"

  },


  grid:{

    left:"5%",
    right:"5%",
    bottom:"10%",
    containLabel:true

  },


  xAxis:{

    type:"category",

    data:props.data.labels

  },


  yAxis:{

    type:"value"

  },


  series:[

    {

      name:"Expenses",

      type:"bar",

      data:props.data.values,


      barWidth:"45%",


      itemStyle:{

        borderRadius:[
          8,
          8,
          0,
          0
        ]

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

margin-bottom:20px;

font-size:22px;

}



.chart{

width:100%;

height:260px;

}



</style>