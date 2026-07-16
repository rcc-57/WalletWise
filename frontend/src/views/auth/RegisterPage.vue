<script setup>
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'

import { useAuthStore } from '@/stores/auth'

import {
  supportedCurrencies
} from '@/utils/currency'

const authStore = useAuthStore()

const form = reactive({
  username: '',
  password: '',
  currency: ''
})

function validateForm() {
  if (!form.username.trim()) {
    ElMessage.warning(
      'Please enter a username.'
    )

    return false
  }

  if (form.username.trim().length < 3) {
    ElMessage.warning(
      'Username must contain at least 3 characters.'
    )

    return false
  }

  if (!form.password) {
    ElMessage.warning(
      'Please enter a password.'
    )

    return false
  }

  if (form.password.length < 6) {
    ElMessage.warning(
      'Password must contain at least 6 characters.'
    )

    return false
  }

  if (!form.currency) {
    ElMessage.warning(
      'Please select your currency.'
    )

    return false
  }

  return true
}

async function submitRegister() {
  if (!validateForm()) {
    return
  }

  try {
    await authStore.register({
      username: form.username,
      password: form.password,
      currency: form.currency
    })

    ElMessage.success(
      'Account created successfully.'
    )
  } catch {
    ElMessage.error(
      authStore.error ||
        'Unable to create your account.'
    )
  }
}
</script>

<template>
  <div class="register-page">
    <div class="register-container">
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
        <h2>Create account</h2>

        <p class="description">
          Start managing your money today
        </p>

        <el-form
          :model="form"
          label-position="top"
          @submit.prevent="submitRegister"
        >
          <el-form-item
            label="Username"
            required
          >
            <el-input
              v-model="form.username"
              maxlength="50"
              placeholder="Choose a username"
            />
          </el-form-item>

          <el-form-item
            label="Password"
            required
          >
            <el-input
              v-model="form.password"
              type="password"
              maxlength="72"
              show-password
              placeholder="Enter a password"
            />
          </el-form-item>

          <el-form-item
            label="Currency"
            required
          >
            <el-select
              v-model="form.currency"
              placeholder="Select your currency"
              style="width: 100%"
            >
              <el-option
                v-for="currency in supportedCurrencies"
                :key="currency.value"
                :label="currency.label"
                :value="currency.value"
              />
            </el-select>
          </el-form-item>

          <el-button
            type="primary"
            native-type="submit"
            class="submit-button"
            :loading="authStore.loading"
          >
            Register
          </el-button>

          <p class="login">
            Already have an account?

            <router-link to="/login">
              Login
            </router-link>
          </p>

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
.register-page {
  display: flex;
  min-height: 100vh;
  justify-content: center;
  align-items: center;
  background: #f3f5f9;
}

.register-container {
  display: flex;
  overflow: hidden;
  width: 900px;
  min-height: 650px;
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
  margin-top: 45px;
  font-size: 90px;
}

.form-side {
  width: 60%;
  padding: 55px 60px;
}

.form-side h2 {
  margin-bottom: 10px;
  font-size: 32px;
}

.description {
  margin-bottom: 24px;
  color: #64748b;
}

.submit-button {
  width: 100%;
}

.login {
  margin-top: 16px;
  text-align: center;
}

.login a {
  color: #2563eb;
}

.error-text {
  margin-top: 12px;
  color: #dc2626;
}
</style>