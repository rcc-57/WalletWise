<script setup>
import { computed } from 'vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
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
</script>

<template>
  <header>
    <div class="left">
      <h2>Welcome back</h2>
    </div>

    <div class="right">
      <span class="notification">🔔</span>

      <div class="user">
        <div class="avatar">{{ initials }}</div>
        <div>
          <b>{{ displayName }}</b>
          <small>Signed in</small>
        </div>
      </div>
    </div>
  </header>
</template>

<style scoped>
header {
  height: 70px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 30px;
  background: white;
  border-bottom: 1px solid #e5e7eb;
}

.left {
  display: flex;
  align-items: center;
  gap: 20px;
}

.left h2 {
  font-size: 20px;
}

.right {
  display: flex;
  align-items: center;
  gap: 25px;
}

.avatar {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  background: #2563eb;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
}

.user {
  display: flex;
  align-items: center;
  gap: 10px;
}

.user small {
  display: block;
  color: #9ca3af;
}
</style>