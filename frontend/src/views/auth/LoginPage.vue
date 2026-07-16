<script setup>
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'

import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

const form = reactive({
  username: '',
  password: ''
})

function validateForm() {
  if (!form.username.trim()) {
    ElMessage.warning(
      'Please enter your username.'
    )

    return false
  }

  if (!form.password) {
    ElMessage.warning(
      'Please enter your password.'
    )

    return false
  }

  return true
}

async function submitLogin() {
  if (!validateForm()) {
    return
  }

  try {
    await authStore.login({
      username: form.username,
      password: form.password
    })

    ElMessage.success(
      'Signed in successfully.'
    )
  } catch {
    ElMessage.error(
      authStore.error ||
        'Unable to sign in.'
    )
  }
}
</script>

<template>
  <div class="login-page">
    <div class="login-container">
      <div class="brand-side">
        <div class="logo">💳</div>

        <h1>WalletWise</h1>

        <p>
          Smart way to manage<br />
          your finances
        </p>

        <div class="wallet">💰</div>
      </div>

      <div class="form-side">
        <h2>Welcome back 👋</h2>

        <p class="description">
          Sign in to continue to your account
        </p>

        <el-form
          :model="form"
          label-position="top"
          @submit.prevent="submitLogin"
        >
          <el-form-item
            label="Username"
            required
          >
            <el-input
              v-model="form.username"
              placeholder="Enter your username"
            />
          </el-form-item>

          <el-form-item
            label="Password"
            required
          >
            <el-input
              v-model="form.password"
              type="password"
              show-password
              placeholder="Enter your password"
            />
          </el-form-item>

          <div class="register-link">
            <span>Do not have an account?</span>

            <router-link to="/register">
              Create account
            </router-link>
          </div>

          <el-button
            type="primary"
            native-type="submit"
            class="submit-button"
            :loading="authStore.loading"
          >
            Login
          </el-button>

          <p
            v-if="authStore.error"
            class="error-text"
          >
            {{ authStore.error }}
          </p>
        </el-form>
      </div>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  display: flex;
  min-height: 100vh;
  justify-content: center;
  align-items: center;
  background: #f3f5f9;
}

.login-container {
  display: flex;
  overflow: hidden;
  width: 900px;
  min-height: 560px;
  border-radius: 20px;
  background: white;
  box-shadow: 0 20px 50px
    rgba(0, 0, 0, 0.12);
}

.brand-side {
  display: flex;
  width: 40%;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  background: #111827;
  color: white;
}

.logo {
  display: flex;
  width: 70px;
  height: 70px;
  justify-content: center;
  align-items: center;
  border-radius: 15px;
  background: #2563eb;
  font-size: 35px;
}

.brand-side h1 {
  margin-top: 25px;
  font-size: 34px;
}

.brand-side p {
  text-align: center;
  color: #cbd5e1;
  line-height: 1.5;
}

.wallet {
  margin-top: 60px;
  font-size: 100px;
}

.form-side {
  width: 60%;
  padding: 70px;
}

.form-side h2 {
  margin-bottom: 10px;
  font-size: 32px;
}

.description {
  margin-bottom: 24px;
  color: #64748b;
}

.register-link {
  display: flex;
  margin-bottom: 20px;
  justify-content: space-between;
  align-items: center;
  color: #64748b;
  font-size: 14px;
}

.register-link a {
  color: #2563eb;
  text-decoration: none;
}

.submit-button {
  width: 100%;
}

.error-text {
  margin-top: 12px;
  color: #dc2626;
}
</style>