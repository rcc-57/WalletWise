<script setup>
import { computed, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElDropdown, ElDropdownMenu, ElDropdownItem, ElBadge } from 'element-plus'
import { Bell, User, Setting, SwitchButton } from '@element-plus/icons-vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
const router = useRouter()
const notifications = ref([
  { id: 1, title: 'New expense added', text: 'A new transaction was recorded', unread: true },
  { id: 2, title: 'Monthly report ready', text: 'Your monthly summary is available', unread: true },
  { id: 3, title: 'Welcome back', text: 'Your dashboard has been refreshed', unread: false }
])

const displayName = computed(() => authStore.user?.username || 'WalletWise User')
const initials = computed(() => {
  const name = displayName.value
  return name
    .split(' ')
    .map((part) => part[0])
    .slice(0, 2)
    .join('')
    .toUpperCase()
})
const unreadCount = computed(() => notifications.value.filter((item) => item.unread).length)

function goToProfile() {
  router.push('/profile')
}

function goToSettings() {
  router.push('/settings')
}

function logout() {
  authStore.logout()
}
</script>

<template>
  <header>
    <div class="left">
      <div>
        <p class="eyebrow">Overview</p>
        <h2>Welcome back</h2>
      </div>
    </div>

    <div class="right">
      <el-dropdown trigger="click" placement="bottom-end">
        <span class="notification-trigger">
          <el-badge :value="unreadCount" :hidden="unreadCount === 0" type="danger">
            <el-icon class="notification-icon"><Bell /></el-icon>
          </el-badge>
        </span>
        <template #dropdown>
          <el-dropdown-menu>
            <div class="dropdown-header">Notifications</div>
            <el-dropdown-item v-for="item in notifications" :key="item.id" :class="item.unread ? 'unread' : ''">
              <div class="notification-item">
                <strong>{{ item.title }}</strong>
                <span>{{ item.text }}</span>
              </div>
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>

      <el-dropdown trigger="click" placement="bottom-end">
        <div class="user">
          <div class="avatar">{{ initials }}</div>
          <div>
            <b>{{ displayName }}</b>
            <small>Signed in</small>
          </div>
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item @click="goToProfile">
              <el-icon><User /></el-icon>
              Profile
            </el-dropdown-item>
            <el-dropdown-item @click="goToSettings">
              <el-icon><Setting /></el-icon>
              Settings
            </el-dropdown-item>
            <el-dropdown-item divided @click="logout">
              <el-icon><SwitchButton /></el-icon>
              Logout
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </header>
</template>

<style scoped>
header {
  height: 74px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 28px;
  background: white;
  border-bottom: 1px solid #e5e7eb;
  box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
}

.left {
  display: flex;
  align-items: center;
  gap: 20px;
}

.eyebrow {
  margin: 0 0 2px;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: #64748b;
}

.left h2 {
  font-size: 20px;
  color: #111827;
  margin: 0;
}

.right {
  display: flex;
  align-items: center;
  gap: 18px;
}

.notification-trigger {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 42px;
  height: 42px;
  border-radius: 50%;
  background: #f8fafc;
  cursor: pointer;
  transition: background 0.2s ease;
}

.notification-trigger:hover {
  background: #eef2ff;
}

.notification-icon {
  font-size: 18px;
  color: #475569;
}

.avatar {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  background: linear-gradient(135deg, #2563eb, #3b82f6);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
}

.user {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 6px 8px;
  border-radius: 999px;
  cursor: pointer;
  transition: background 0.2s ease;
}

.user:hover {
  background: #f8fafc;
}

.user small {
  display: block;
  color: #94a3b8;
}

.dropdown-header {
  padding: 8px 14px 4px;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: #64748b;
}

.notification-item {
  display: flex;
  flex-direction: column;
  gap: 2px;
  padding: 2px 0;
}

.notification-item span {
  color: #64748b;
  font-size: 12px;
}

.unread {
  background: #f8fafc;
}
</style>