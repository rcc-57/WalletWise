<script setup>
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

function logout() {
  authStore.logout()
}
</script>

<template>
  <aside class="sidebar">
    <div class="logo">WalletWise</div>

    <nav>
      <router-link to="/dashboard">🏠 Dashboard</router-link>
      <router-link to="/expenses">💳 Expenses</router-link>
      <router-link to="/income">💰 Income</router-link>
      <router-link to="/analytics">📊 Analytics</router-link>
    </nav>

    <button class="logout" @click="logout">🚪 Logout</button>
  </aside>
</template>

<style scoped>
aside {
  width: 250px;
  min-height: calc(100vh - 60px);
  background: #111827;
  padding: 20px;
  display: flex;
  flex-direction: column;
}

.logo {
  color: white;
  font-size: 24px;
  font-weight: 700;
  margin-bottom: 40px;
}

nav {
  flex: 1;
}

a {
  display: block;
  color: #cbd5e1;
  padding: 14px 15px;
  margin-bottom: 12px;
  border-radius: 12px;
  text-decoration: none;
}

a:hover,
a.router-link-active {
  background: #2563eb;
  color: white;
}

.logout {
  color: #f87171;
  background: transparent;
  border: none;
  text-align: left;
  padding: 14px 15px;
  cursor: pointer;
  font-size: 15px;
}
</style>