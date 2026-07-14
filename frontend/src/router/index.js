import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

import MainLayout from '../layouts/MainLayout.vue'

import LoginPage from '../views/auth/LoginPage.vue'
import RegisterPage from '../views/auth/RegisterPage.vue'
import DashboardPage from '../views/dashboard/DashboardPage.vue'
import ExpensesPage from '../views/expenses/ExpensesPage.vue'
import IncomePage from '../views/income/IncomePage.vue'
import AnalyticsPage from '../views/analytics/AnalyticsPage.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),

  routes: [
    {
      path: '/',
      redirect: '/login'
    },
    {
      path: '/login',
      name: 'Login',
      component: LoginPage
    },
    {
      path: '/register',
      name: 'Register',
      component: RegisterPage
    },
    {
      path: '/',
      component: MainLayout,
      meta: { requiresAuth: true },
      children: [
        {
          path: 'dashboard',
          name: 'Dashboard',
          component: DashboardPage
        },
        {
          path: 'expenses',
          name: 'Expenses',
          component: ExpensesPage
        },
        {
          path: 'income',
          name: 'Income',
          component: IncomePage
        },
        {
          path: 'analytics',
          name: 'Analytics',
          component: AnalyticsPage
        }
      ]
    }
  ]
})

router.beforeEach(async (to) => {
  const authStore = useAuthStore()

  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    return { name: 'Login' }
  }

  return true
})

export default router