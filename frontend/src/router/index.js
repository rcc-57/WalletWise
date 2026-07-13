import { createRouter, createWebHistory } from 'vue-router'

import MainLayout from '../layouts/MainLayout.vue'

import LoginPage from '../views/auth/LoginPage.vue'
import RegisterPage from '../views/auth/RegisterPage.vue'
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
      path:'/register',
      name:'Register',
      component:RegisterPage
    },

    {
      path: '/',
      component: MainLayout,

      children: [

        {
          path: 'dashboard',
          name: 'Dashboard',
          component: DashboardPage,
        },


        {
          path: 'expenses',
          name: 'Expenses',
          component: ExpensesPage,
        },

      ],
    },

  ],
})

export default router