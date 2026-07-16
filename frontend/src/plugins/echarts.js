import { use } from 'echarts/core'

import {
  LineChart,
  PieChart
} from 'echarts/charts'

import {
  GridComponent,
  LegendComponent,
  TooltipComponent
} from 'echarts/components'

import {
  CanvasRenderer
} from 'echarts/renderers'

import VChart from 'vue-echarts'

use([
  LineChart,
  PieChart,
  GridComponent,
  LegendComponent,
  TooltipComponent,
  CanvasRenderer
])

export default VChart