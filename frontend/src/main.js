import { createApp } from 'vue'
import { createPinia } from 'pinia'

import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

import App from './App.vue'
import router from './router'
import VChart from './plugins/echarts'

import { useAuthStore } from './stores/auth'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)
app.use(ElementPlus)

app.component(
  'VChart',
  VChart
)

const authStore = useAuthStore()

if (authStore.token) {
  authStore
    .fetchCurrentUser()
    .catch(() => {})
}

app.mount('#app')