<script setup>
import {
  computed,
  onMounted,
  reactive,
  ref,
  watch
} from 'vue'

import { ElMessage } from 'element-plus'

import { useAuthStore } from '@/stores/auth'

import {
  getCurrencyLabel,
  supportedCurrencies
} from '@/utils/currency'

const authStore = useAuthStore()

const form = reactive({
  username: '',
  email: '',
  currency: ''
})

const savedMessage = ref('')

const initials = computed(() => {
  const username =
    authStore.user?.username || ''

  return username
    .slice(0, 2)
    .toUpperCase()
})

const createdAtLabel = computed(() => {
  const createdAt =
    authStore.user?.createdAt

  if (!createdAt) {
    return ''
  }

  return new Date(
    createdAt
  ).toLocaleDateString()
})

const currencyLabel = computed(() => {
  return getCurrencyLabel(
    authStore.user?.currency
  )
})

function fillFormFromUser(user) {
  form.username =
    user?.username || ''

  form.email =
    user?.email || ''

  form.currency =
    user?.currency || ''
}

function validateEmail(email) {
  if (!email) {
    return true
  }

  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(
    email
  )
}

async function saveProfile() {
  savedMessage.value = ''

  const normalizedEmail =
    form.email.trim()

  if (
    !validateEmail(normalizedEmail)
  ) {
    ElMessage.warning(
      'Please enter a valid email address.'
    )

    return
  }

  if (!form.currency) {
    ElMessage.warning(
      'Please select a currency.'
    )

    return
  }

  try {
    await authStore.updateProfile({
      email:
        normalizedEmail || null,
      currency:
        form.currency
    })

    savedMessage.value =
      'Profile saved successfully.'

    ElMessage.success(
      'Profile saved successfully.'
    )
  } catch {
    ElMessage.error(
      authStore.error ||
        'Unable to save profile.'
    )
  }
}

function resetProfile() {
  fillFormFromUser(
    authStore.user
  )

  savedMessage.value = ''
}

watch(
  () => authStore.user,
  (user) => {
    fillFormFromUser(user)
  },
  {
    immediate: true,
    deep: true
  }
)

onMounted(async () => {
  if (!authStore.user) {
    try {
      await authStore.fetchCurrentUser()
    } catch {
      ElMessage.error(
        'Unable to load profile.'
      )
    }
  }
})
</script>

<template>
  <div class="profile-page">
    <div class="page-header">
      <div>
        <h1>Profile</h1>

        <p>
          Manage your account information
          and preferred currency
        </p>
      </div>
    </div>

    <div
      class="profile-hero"
      v-loading="authStore.loading"
    >
      <div class="avatar">
        {{ initials }}
      </div>

      <div class="hero-content">
        <h2>
          {{ authStore.user?.username }}
        </h2>

        <p v-if="authStore.user?.email">
          {{ authStore.user.email }}
        </p>

        <p v-else>
          No email added
        </p>
      </div>
    </div>

    <el-card
      shadow="never"
      class="profile-card"
    >
      <template #header>
        <div class="card-header">
          Account details
        </div>
      </template>

      <el-form
        label-position="top"
        @submit.prevent="saveProfile"
      >
        <el-form-item label="Username">
          <el-input
            v-model="form.username"
            readonly
          />

          <p class="field-hint">
            Username is created during
            registration and cannot be changed.
          </p>
        </el-form-item>

        <el-form-item label="Email">
          <el-input
            v-model="form.email"
            type="email"
            maxlength="255"
            placeholder="Add your email address"
            clearable
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

        <div class="account-information">
          <div>
            <span>Current currency</span>

            <strong>
              {{ currencyLabel }}
            </strong>
          </div>

          <div>
            <span>Account created</span>

            <strong>
              {{ createdAtLabel }}
            </strong>
          </div>
        </div>

        <div class="actions">
          <el-button
            type="primary"
            native-type="submit"
            :loading="authStore.loading"
          >
            Save changes
          </el-button>

          <el-button
            :disabled="authStore.loading"
            @click="resetProfile"
          >
            Reset
          </el-button>
        </div>

        <p
          v-if="savedMessage"
          class="success-message"
        >
          {{ savedMessage }}
        </p>

        <p
          v-if="authStore.error"
          class="error-message"
        >
          {{ authStore.error }}
        </p>
      </el-form>
    </el-card>
  </div>
</template>

<style scoped>
.profile-page {
  display: flex;
  max-width: 900px;
  flex-direction: column;
  gap: 20px;
}

.page-header h1 {
  margin: 0 0 6px;
  color: #111827;
  font-size: 32px;
  font-weight: 700;
}

.page-header p {
  margin: 0;
  color: #64748b;
  font-size: 14px;
}

.profile-hero {
  display: flex;
  padding: 24px;
  align-items: center;
  gap: 16px;
  border-radius: 20px;
  background: linear-gradient(
    135deg,
    #111827,
    #1f2937
  );
  color: white;
  box-shadow: 0 10px 30px
    rgba(15, 23, 42, 0.12);
}

.avatar {
  display: flex;
  width: 58px;
  height: 58px;
  justify-content: center;
  align-items: center;
  flex-shrink: 0;
  border-radius: 50%;
  background: linear-gradient(
    135deg,
    #2563eb,
    #60a5fa
  );
  font-weight: 700;
}

.hero-content h2 {
  margin: 0 0 5px;
  font-size: 22px;
}

.hero-content p {
  margin: 0;
  color: #cbd5e1;
}

.profile-card {
  border-radius: 18px;
}

.card-header {
  color: #111827;
  font-weight: 600;
}

.field-hint {
  margin: 6px 0 0;
  color: #94a3b8;
  font-size: 12px;
}

.account-information {
  display: grid;
  grid-template-columns: repeat(
    2,
    minmax(0, 1fr)
  );
  gap: 16px;
  margin: 8px 0 20px;
}

.account-information div {
  display: flex;
  padding: 14px;
  flex-direction: column;
  gap: 5px;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  background: #f8fafc;
}

.account-information span {
  color: #64748b;
  font-size: 12px;
}

.account-information strong {
  min-height: 20px;
  color: #111827;
}

.actions {
  display: flex;
  gap: 12px;
}

.success-message {
  margin-top: 12px;
  color: #16a34a;
}

.error-message {
  margin-top: 12px;
  color: #dc2626;
}

@media (max-width: 700px) {
  .account-information {
    grid-template-columns: 1fr;
  }
}
</style>