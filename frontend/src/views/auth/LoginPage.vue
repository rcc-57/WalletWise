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
        <h2>Welcome back</h2>

        <p class="description">
          Sign in to review your income,
          everyday spending and savings
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
              autocomplete="username"
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
              autocomplete="current-password"
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
.login-page {
  display: flex;
  min-height: 100vh;
  padding: 24px;
  justify-content: center;
  align-items: center;
  box-sizing: border-box;
  background: #f3f5f9;
}

.login-container {
  display: flex;
  overflow: hidden;
  width: min(920px, 100%);
  min-height: 580px;
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
  margin-top: 48px;
  font-size: 90px;
  line-height: 1;
}

.form-side {
  width: 60%;
  padding: 70px;
  box-sizing: border-box;
}

.form-side h2 {
  margin: 0 0 10px;
  color: #172033;
  font-size: 34px;
  line-height: 1.25;
}

.description {
  margin: 0 0 28px;
  color: #52627a;
  font-size: 17px;
  line-height: 1.6;
}

.register-link {
  display: flex;
  margin-bottom: 22px;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  color: #52627a;
  font-size: 15px;
}

.register-link a {
  color: #1d4ed8;
  text-decoration: none;
}

.register-link a:hover {
  text-decoration: underline;
}

.submit-button {
  width: 100%;
  min-height: 48px;
  font-size: 17px;
}

.error-text {
  margin-top: 14px;
  color: #b91c1c;
  font-weight: 600;
}

@media (max-width: 760px) {
  .login-page {
    padding: 16px;
    align-items: flex-start;
  }

  .login-container {
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

  .register-link {
    align-items: flex-start;
    flex-direction: column;
    gap: 6px;
  }
}
</style>