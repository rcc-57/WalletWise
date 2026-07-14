<script setup>
import { reactive } from 'vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

const form = reactive({
  username: '',
  password: ''
})

async function submitRegister() {
  try {
    await authStore.register({
      username: form.username,
      password: form.password
    })
  } catch (error) {
    console.error(error)
  }
}
</script>

<template>
  <div class="register-page">
    <div class="register-container">
      <div class="brand-side">
        <div class="logo">💳</div>
        <h1>WalletWise</h1>
        <p>Smart way to manage<br />your finances</p>
        <div class="wallet">💰</div>
      </div>

      <div class="form-side">
        <h2>Create account</h2>
        <p class="description">Start managing your money today</p>

        <el-form :model="form" @submit.prevent="submitRegister">
          <el-form-item label="Username">
            <el-input v-model="form.username" placeholder="Choose a username" />
          </el-form-item>

          <el-form-item label="Password">
            <el-input v-model="form.password" type="password" placeholder="••••••••" />
          </el-form-item>

          <el-button type="primary" class="submit-button" :loading="authStore.loading" @click="submitRegister">
            Register
          </el-button>

          <p class="login">
            Already have an account?
            <router-link to="/login">Login</router-link>
          </p>

          <p v-if="authStore.error" class="error-text">{{ authStore.error }}</p>
        </el-form>
      </div>
    </div>
  </div>
</template>

<style scoped>
.register-page {
  min-height: 100vh;
  background: #f3f5f9;
  display: flex;
  justify-content: center;
  align-items: center;
}

.register-container {
  width: 900px;
  min-height: 620px;
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
  justify-content: center;
  align-items: center;
}

.logo {
  width: 70px;
  height: 70px;
  background: #2563eb;
  border-radius: 15px;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 35px;
}

.brand-side h1 {
  margin-top: 25px;
  font-size: 34px;
}

.brand-side p {
  color: #cbd5e1;
  text-align: center;
}

.wallet {
  margin-top: 60px;
  font-size: 100px;
}

.form-side {
  width: 60%;
  padding: 60px;
}

.form-side h2 {
  font-size: 32px;
  margin-bottom: 10px;
}

.description {
  color: #64748b;
  margin-bottom: 24px;
}

.submit-button {
  width: 100%;
}

.login {
  text-align: center;
  margin-top: 16px;
}

.login a {
  color: #2563eb;
}

.error-text {
  margin-top: 12px;
  color: #dc2626;
}
</style>
