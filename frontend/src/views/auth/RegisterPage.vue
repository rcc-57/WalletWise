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
        <div
          class="logo"
          aria-hidden="true"
        >
          💳
        </div>

        <h1>WalletWise</h1>

        <p class="brand-description">
          Simple and clear money management
          for a comfortable retirement
        </p>

        <div
          class="wallet"
          aria-hidden="true"
        >
          💰
        </div>
      </div>

      <div class="form-side">
        <h2>Create account</h2>

        <p class="description">
          Keep your pension, benefits,
          healthcare costs and everyday
          expenses in one clear place
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
              autocomplete="username"
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
              autocomplete="new-password"
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
            role="alert"
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
  padding: 24px;
  justify-content: center;
  align-items: center;
  box-sizing: border-box;
  background: #f3f5f9;
}

.register-container {
  display: flex;
  overflow: hidden;
  width: min(920px, 100%);
  min-height: 670px;
  border-radius: 20px;
  background: white;
  box-shadow: 0 20px 50px
    rgba(0, 0, 0, 0.12);
}

.brand-side {
  display: flex;
  width: 40%;
  padding: 48px 36px;
  box-sizing: border-box;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  background: #111827;
  color: white;
}

.logo {
  display: flex;
  width: 74px;
  height: 74px;
  justify-content: center;
  align-items: center;
  border-radius: 16px;
  background: #2563eb;
  font-size: 38px;
}

.brand-side h1 {
  margin: 25px 0 12px;
  font-size: 36px;
  line-height: 1.2;
}

.brand-description {
  max-width: 270px;
  margin: 0;
  text-align: center;
  color: #dbe4f0;
  font-size: 17px;
  line-height: 1.6;
}

.wallet {
  margin-top: 44px;
  font-size: 86px;
  line-height: 1;
}

.form-side {
  width: 60%;
  padding: 54px 60px;
  box-sizing: border-box;
}

.form-side h2 {
  margin: 0 0 10px;
  color: #172033;
  font-size: 34px;
  line-height: 1.25;
}

.description {
  margin: 0 0 25px;
  color: #52627a;
  font-size: 17px;
  line-height: 1.6;
}

.submit-button {
  width: 100%;
  min-height: 48px;
  font-size: 17px;
}

.login {
  margin-top: 18px;
  text-align: center;
  color: #52627a;
}

.login a {
  color: #1d4ed8;
  text-decoration: none;
}

.login a:hover {
  text-decoration: underline;
}

.error-text {
  margin-top: 14px;
  color: #b91c1c;
  font-weight: 600;
}

@media (max-width: 760px) {
  .register-page {
    padding: 16px;
    align-items: flex-start;
  }

  .register-container {
    flex-direction: column;
  }

  .brand-side,
  .form-side {
    width: 100%;
  }

  .brand-side {
    padding: 32px 24px;
  }

  .wallet {
    display: none;
  }

  .form-side {
    padding: 36px 24px;
  }
}
</style>