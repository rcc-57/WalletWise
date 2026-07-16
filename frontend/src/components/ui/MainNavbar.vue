<script setup>
import { computed } from 'vue'

import { useRouter } from 'vue-router'

import {
  SwitchButton,
  User
} from '@element-plus/icons-vue'

import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
const router = useRouter()

const displayName = computed(() => {
  return authStore.user?.username || ''
})

const initials = computed(() => {
  return displayName.value
    .slice(0, 2)
    .toUpperCase()
})

function goToProfile() {
  router.push('/profile')
}

async function logout() {
  await authStore.logout()
}
</script>

<template>
  <header>
    <div class="left">
      <div>
        <p class="eyebrow">
          WalletWise
        </p>

        <h2>
          Personal finance management
        </h2>
      </div>
    </div>

    <div class="right">
      <el-dropdown
        trigger="click"
        placement="bottom-end"
      >
        <div class="user">
          <div class="avatar">
            {{ initials }}
          </div>

          <div class="user-information">
            <b>{{ displayName }}</b>
            <small>Signed in</small>
          </div>
        </div>

        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item
              @click="goToProfile"
            >
              <el-icon>
                <User />
              </el-icon>

              Profile
            </el-dropdown-item>

            <el-dropdown-item
              divided
              @click="logout"
            >
              <el-icon>
                <SwitchButton />
              </el-icon>

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
  display: flex;
  height: 74px;
  padding: 0 28px;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #e5e7eb;
  background: white;
  box-shadow: 0 1px 2px
    rgba(15, 23, 42, 0.04);
}

.eyebrow {
  margin: 0 0 2px;
  color: #64748b;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.12em;
}

.left h2 {
  margin: 0;
  color: #111827;
  font-size: 20px;
}

.right {
  display: flex;
  align-items: center;
}

.avatar {
  display: flex;
  width: 42px;
  height: 42px;
  justify-content: center;
  align-items: center;
  border-radius: 50%;
  background: linear-gradient(
    135deg,
    #2563eb,
    #3b82f6
  );
  color: white;
  font-weight: 700;
}

.user {
  display: flex;
  padding: 6px 8px;
  align-items: center;
  gap: 10px;
  border-radius: 999px;
  cursor: pointer;
  transition: background 0.2s ease;
}

.user:hover {
  background: #f8fafc;
}

.user-information small {
  display: block;
  color: #94a3b8;
}
</style>