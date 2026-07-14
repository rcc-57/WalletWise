<script setup>
import { reactive } from 'vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

const form = reactive({
  username: '',
  password: ''
})

async function submitLogin() {
  try {
    await authStore.login({
      username: form.username,
      password: form.password
    })
  } catch (error) {
    console.error(error)
  }
}
</script>

<template>
  <div class="login-page">
    <div class="login-container">
      <div class="brand-side">
        <div class="logo">💳</div>
        <h1>WalletWise</h1>
        <p>Smart way to manage<br />your finances</p>
        <div class="wallet">💰</div>
      </div>

      <div class="form-side">
        <h2>Welcome back 👋</h2>
        <p class="description">Sign in to continue to your account</p>

        <el-form :model="form" @submit.prevent="submitLogin">
          <el-form-item label="Username">
            <el-input v-model="form.username" placeholder="Enter your username" />
          </el-form-item>

          <el-form-item label="Password">
            <el-input v-model="form.password" type="password" placeholder="••••••••" />
          </el-form-item>

          <div class="options">
            <label class="remember">
              <input type="checkbox" />
              Remember me
            </label>
            <router-link to="/register">Create account</router-link>
          </div>

          <p class="helper-text">
            Demo access: <strong>demo_walletwise</strong> / <strong>Demo123!</strong>
          </p>

          <el-button type="primary" class="submit-button" :loading="authStore.loading" @click="submitLogin">
            Login
          </el-button>

          <p v-if="authStore.error" class="error-text">{{ authStore.error }}</p>
        </el-form>
      </div>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  min-height: 100vh;
  background: #f3f5f9;
  display: flex;
  justify-content: center;
  align-items: center;
}

.login-container {
  width: 900px;
  min-height: 560px;
  display: flex;
  background: white;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.12);
}

.brand-side {
  width: 40%;
  background: #111827;
  color: white;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.logo {
  width: 70px;
  height: 70px;
  background: #2563eb;
  border-radius: 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 35px;
}

.brand-side h1 {
  font-size: 34px;
  margin-top: 25px;
}

.brand-side p {
  color: #cbd5e1;
  text-align: center;
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
  font-size: 32px;
  margin-bottom: 10px;
}

.description {
  color: #64748b;
  margin-bottom: 24px;
}

.options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.remember {
  display: flex;
  gap: 8px;
  align-items: center;
  font-weight: 400;
}

.options a {
  color: #2563eb;
  text-decoration: none;
}

.submit-button {
  width: 100%;
}

.helper-text {
  margin: 8px 0 16px;
  color: #64748b;
}

.error-text {
  margin-top: 12px;
  color: #dc2626;
}
</style>