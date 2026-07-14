<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { ElIcon } from 'element-plus'
import {
  House,
  Wallet,
  TrendCharts,
  DataLine,
  User,
  Setting,
  SwitchButton
} from '@element-plus/icons-vue'

const route = useRoute()
const authStore = useAuthStore()

const items = computed(() => [
  { to: '/dashboard', label: 'Dashboard', icon: House },
  { to: '/expenses', label: 'Expenses', icon: Wallet },
  { to: '/income', label: 'Income', icon: TrendCharts },
  { to: '/analytics', label: 'Analytics', icon: DataLine },
  { to: '/profile', label: 'Profile', icon: User },
  { to: '/settings', label: 'Settings', icon: Setting }
])

function logout() {
  authStore.logout()
}
</script>

<template>
  <aside class="sidebar">
    <div class="brand-block">
      <div class="brand-icon">W</div>
      <div>
        <div class="brand-name">WalletWise</div>
        <div class="brand-subtitle">Finance control</div>
      </div>
    </div>

    <nav>
      <router-link v-for="item in items" :key="item.to" :to="item.to" class="nav-link">
        <el-icon class="nav-icon"><component :is="item.icon" /></el-icon>
        <span>{{ item.label }}</span>
      </router-link>
    </nav>

    <button class="logout" @click="logout">
      <el-icon><SwitchButton /></el-icon>
      <span>Logout</span>
    </button>
  </aside>
</template>

<style scoped>
.sidebar {
  width: 250px;
  min-height: 100vh;
  background: linear-gradient(180deg, #111827 0%, #0f172a 100%);
  padding: 24px 18px;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.brand-block {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 6px 18px;
  border-bottom: 1px solid rgba(255,255,255,0.08);
}

.brand-icon {
  width: 42px;
  height: 42px;
  border-radius: 12px;
  background: linear-gradient(135deg, #2563eb, #3b82f6);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: 700;
}

.brand-name {
  color: white;
  font-weight: 700;
  font-size: 16px;
}

.brand-subtitle {
  color: #94a3b8;
  font-size: 12px;
}

nav {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.nav-link {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #cbd5e1;
  padding: 12px 14px;
  border-radius: 12px;
  text-decoration: none;
  transition: all 0.2s ease;
}

.nav-link:hover,
.nav-link.router-link-active {
  background: rgba(37, 99, 235, 0.18);
  color: white;
  transform: translateX(2px);
}

.nav-icon {
  font-size: 16px;
}

.logout {
  color: #fda4af;
  background: rgba(248, 113, 113, 0.1);
  border: none;
  border-radius: 12px;
  text-align: left;
  padding: 12px 14px;
  cursor: pointer;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: all 0.2s ease;
}

.logout:hover {
  background: rgba(248, 113, 113, 0.18);
}
</style>