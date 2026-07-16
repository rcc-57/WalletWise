<script setup>
import { computed } from 'vue'

import {
  House,
  SwitchButton,
  TrendCharts,
  User,
  Wallet
} from '@element-plus/icons-vue'

import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

const items = computed(() => [
  {
    to: '/dashboard',
    label: 'Dashboard',
    icon: House
  },
  {
    to: '/expenses',
    label: 'Expenses',
    icon: Wallet
  },
  {
    to: '/income',
    label: 'Income',
    icon: TrendCharts
  },
  {
    to: '/profile',
    label: 'Profile',
    icon: User
  }
])

async function logout() {
  await authStore.logout()
}
</script>

<template>
  <aside class="sidebar">
    <div class="brand-block">
      <div class="brand-icon">
        W
      </div>

      <div>
        <div class="brand-name">
          WalletWise
        </div>

        <div class="brand-subtitle">
          Finance control
        </div>
      </div>
    </div>

    <nav>
      <router-link
        v-for="item in items"
        :key="item.to"
        :to="item.to"
        class="nav-link"
      >
        <el-icon class="nav-icon">
          <component
            :is="item.icon"
          />
        </el-icon>

        <span>
          {{ item.label }}
        </span>
      </router-link>
    </nav>

    <button
      class="logout"
      @click="logout"
    >
      <el-icon>
        <SwitchButton />
      </el-icon>

      <span>Logout</span>
    </button>
  </aside>
</template>

<style scoped>
.sidebar {
  display: flex;
  width: 250px;
  min-height: 100vh;
  padding: 24px 18px;
  flex-direction: column;
  gap: 24px;
  background: linear-gradient(
    180deg,
    #111827 0%,
    #0f172a 100%
  );
}

.brand-block {
  display: flex;
  padding: 8px 6px 18px;
  align-items: center;
  gap: 12px;
  border-bottom: 1px solid
    rgba(255, 255, 255, 0.08);
}

.brand-icon {
  display: flex;
  width: 42px;
  height: 42px;
  justify-content: center;
  align-items: center;
  border-radius: 12px;
  background: linear-gradient(
    135deg,
    #2563eb,
    #3b82f6
  );
  color: white;
  font-weight: 700;
}

.brand-name {
  color: white;
  font-size: 16px;
  font-weight: 700;
}

.brand-subtitle {
  color: #94a3b8;
  font-size: 12px;
}

nav {
  display: flex;
  flex: 1;
  flex-direction: column;
  gap: 6px;
}

.nav-link {
  display: flex;
  padding: 12px 14px;
  align-items: center;
  gap: 10px;
  border-radius: 12px;
  color: #cbd5e1;
  text-decoration: none;
  transition: all 0.2s ease;
}

.nav-link:hover,
.nav-link.router-link-active {
  transform: translateX(2px);
  background: rgba(
    37,
    99,
    235,
    0.18
  );
  color: white;
}

.nav-icon {
  font-size: 16px;
}

.logout {
  display: flex;
  padding: 12px 14px;
  align-items: center;
  gap: 10px;
  border: none;
  border-radius: 12px;
  background: rgba(
    248,
    113,
    113,
    0.1
  );
  color: #fda4af;
  text-align: left;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.2s ease;
}

.logout:hover {
  background: rgba(
    248,
    113,
    113,
    0.18
  );
}
</style>