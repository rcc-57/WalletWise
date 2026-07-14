<script setup>
import { computed, reactive, ref } from 'vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

const profileForm = reactive({
  username: authStore.user?.username || 'WalletWise User',
  email: 'you@example.com',
  monthlyGoal: 5000
})

const savedMessage = ref('')
const displayName = computed(() => authStore.user?.username || profileForm.username)

function saveProfile() {
  savedMessage.value = 'Profile details have been updated locally for now.'
}

function resetProfile() {
  profileForm.username = authStore.user?.username || 'WalletWise User'
  profileForm.email = 'you@example.com'
  profileForm.monthlyGoal = 5000
  savedMessage.value = ''
}
</script>

<template>
  <div class="page">
    <div class="page-header">
      <div>
        <h1>Profile</h1>
        <p>Manage your personal information and savings goals</p>
      </div>
    </div>

    <div class="content-grid">
      <el-card shadow="never" class="card">
        <template #header>
          <div class="card-header">
            <span>Personal information</span>
          </div>
        </template>

        <el-form label-position="top">
          <el-form-item label="Username">
            <el-input v-model="profileForm.username" placeholder="Enter your username" />
          </el-form-item>

          <el-form-item label="Email">
            <el-input v-model="profileForm.email" placeholder="you@example.com" />
          </el-form-item>

          <el-form-item label="Monthly goal">
            <el-input-number v-model="profileForm.monthlyGoal" :min="0" style="width: 100%;" />
          </el-form-item>

          <div class="actions">
            <el-button type="primary" @click="saveProfile">Save changes</el-button>
            <el-button @click="resetProfile">Reset</el-button>
          </div>

          <p v-if="savedMessage" class="helper-text">{{ savedMessage }}</p>
        </el-form>
      </el-card>

      <el-card shadow="never" class="card">
        <template #header>
          <div class="card-header">
            <span>Account summary</span>
          </div>
        </template>

        <div class="summary-list">
          <div>
            <strong>Signed in as</strong>
            <p>{{ displayName }}</p>
          </div>
          <div>
            <strong>Current savings goal</strong>
            <p>${{ profileForm.monthlyGoal.toLocaleString() }}</p>
          </div>
          <div>
            <strong>Plan status</strong>
            <p>Ready for the next month</p>
          </div>
        </div>
      </el-card>
    </div>
  </div>
</template>

<style scoped>
.page {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.page-header h1 {
  font-size: 34px;
  font-weight: 700;
  color: #111827;
  margin-bottom: 6px;
}

.page-header p {
  font-size: 15px;
  color: #6b7280;
}

.content-grid {
  display: grid;
  grid-template-columns: 1.4fr 1fr;
  gap: 24px;
}

.card {
  border-radius: 18px;
}

.card-header {
  font-weight: 600;
  color: #111827;
}

.actions {
  display: flex;
  gap: 12px;
  margin-top: 8px;
}

.helper-text {
  margin-top: 12px;
  color: #2563eb;
}

.summary-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.summary-list strong {
  color: #111827;
}

.summary-list p {
  margin-top: 4px;
  color: #6b7280;
}

@media (max-width: 900px) {
  .content-grid {
    grid-template-columns: 1fr;
  }
}
</style>
