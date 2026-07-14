<script setup>
import { computed, reactive, ref } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { User, Coin, Document } from '@element-plus/icons-vue'

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
        <p>Keep your account details and targets organized</p>
      </div>
    </div>

    <div class="hero-card">
      <div class="avatar-section">
        <div class="avatar">{{ displayName.slice(0, 2).toUpperCase() }}</div>
        <div>
          <h2>{{ displayName }}</h2>
          <p>Premium finance planning</p>
        </div>
      </div>
      <div class="hero-stats">
        <div>
          <span>Active goals</span>
          <strong>3</strong>
        </div>
        <div>
          <span>Monthly target</span>
          <strong>${{ profileForm.monthlyGoal.toLocaleString() }}</strong>
        </div>
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

      <div class="stack">
        <el-card shadow="never" class="card">
          <template #header>
            <div class="card-header">
              <span>Account summary</span>
            </div>
          </template>

          <div class="summary-list">
            <div class="summary-item">
              <el-icon><User /></el-icon>
              <div>
                <strong>Signed in as</strong>
                <p>{{ displayName }}</p>
              </div>
            </div>
            <div class="summary-item">
              <el-icon><Coin /></el-icon>
              <div>
                <strong>Current savings goal</strong>
                <p>${{ profileForm.monthlyGoal.toLocaleString() }}</p>
              </div>
            </div>
            <div class="summary-item">
              <el-icon><Document /></el-icon>
              <div>
                <strong>Plan status</strong>
                <p>Ready for the next month</p>
              </div>
            </div>
          </div>
        </el-card>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.page-header h1 {
  font-size: 32px;
  font-weight: 700;
  color: #111827;
  margin-bottom: 6px;
}

.page-header p {
  font-size: 14px;
  color: #64748b;
}

.hero-card {
  background: linear-gradient(135deg, #111827, #1f2937);
  color: white;
  border-radius: 20px;
  padding: 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 10px 30px rgba(15, 23, 42, 0.12);
}

.avatar-section {
  display: flex;
  align-items: center;
  gap: 14px;
}

.avatar {
  width: 54px;
  height: 54px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #2563eb, #60a5fa);
  font-weight: 700;
}

.avatar-section h2 {
  margin: 0 0 4px;
  font-size: 20px;
}

.avatar-section p {
  margin: 0;
  color: #cbd5e1;
}

.hero-stats {
  display: flex;
  gap: 20px;
}

.hero-stats div {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 110px;
}

.hero-stats span {
  color: #cbd5e1;
  font-size: 12px;
}

.hero-stats strong {
  font-size: 16px;
}

.content-grid {
  display: grid;
  grid-template-columns: 1.4fr 1fr;
  gap: 20px;
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
  gap: 14px;
}

.summary-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.summary-item strong {
  color: #111827;
}

.summary-item p {
  margin-top: 4px;
  color: #64748b;
}

@media (max-width: 900px) {
  .content-grid,
  .hero-card {
    grid-template-columns: 1fr;
    flex-direction: column;
    align-items: flex-start;
  }

  .hero-stats {
    margin-top: 12px;
  }
}
</style>
