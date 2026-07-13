import { createRouter, createWebHistory } from 'vue-router'

import LoginPage from '../views/LoginPage.vue'
import DashboardPage from '../views/DashboardPage.vue'
import ExpensesPage from '../views/ExpensesPage.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),

  routes: [
    {
      path: '/',
      redirect: '/login',
    },

    {
      path: '/login',
      name: 'Login',
      component: LoginPage,
    },

    {
      path: '/dashboard',
      name: 'Dashboard',
      component: DashboardPage,
    },

    {
      path: '/expenses',
      name: 'Expenses',
      component: ExpensesPage,
    },
  ],
})

export default router