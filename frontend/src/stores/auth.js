import { defineStore } from 'pinia'

import {
  computed,
  ref
} from 'vue'

import { useRouter } from 'vue-router'

import apiClient from '@/api/client'

import {
  getCurrentProfile,
  saveCurrentProfile
} from '@/api/profile'

function getErrorMessage(
  error,
  fallbackMessage
) {
  return (
    error.response?.data?.message ||
    fallbackMessage
  )
}

export const useAuthStore = defineStore(
  'auth',
  () => {
    const router = useRouter()

    const user = ref(null)

    const token = ref(
      localStorage.getItem(
        'walletwise_token'
      ) || ''
    )

    const loading = ref(false)
    const error = ref('')

    const isAuthenticated = computed(() => {
      return Boolean(token.value)
    })

    function setAuthSession(authData) {
      const newToken =
        authData?.token || ''

      const newUser =
        authData?.user || null

      token.value = newToken
      user.value = newUser

      if (newToken) {
        localStorage.setItem(
          'walletwise_token',
          newToken
        )
      } else {
        localStorage.removeItem(
          'walletwise_token'
        )
      }
    }

    function clearAuthSession() {
      token.value = ''
      user.value = null

      localStorage.removeItem(
        'walletwise_token'
      )
    }

    async function login(credentials) {
      loading.value = true
      error.value = ''

      try {
        const response =
          await apiClient.post(
            '/api/auth/login',
            {
              username:
                credentials.username.trim(),
              password:
                credentials.password
            }
          )

        setAuthSession(response.data)

        await fetchCurrentUser()
        await router.push('/dashboard')

        return response.data
      } catch (requestError) {
        clearAuthSession()

        error.value = getErrorMessage(
          requestError,
          'Unable to sign in. Check your username and password.'
        )

        throw requestError
      } finally {
        loading.value = false
      }
    }

    async function register(credentials) {
      loading.value = true
      error.value = ''

      try {
        const response =
          await apiClient.post(
            '/api/auth/register',
            {
              username:
                credentials.username.trim(),
              password:
                credentials.password,
              currency:
                credentials.currency
            }
          )

        setAuthSession(response.data)

        await fetchCurrentUser()
        await router.push('/dashboard')

        return response.data
      } catch (requestError) {
        clearAuthSession()

        error.value = getErrorMessage(
          requestError,
          'Unable to create your account.'
        )

        throw requestError
      } finally {
        loading.value = false
      }
    }

    async function fetchCurrentUser() {
      if (!token.value) {
        user.value = null
        return null
      }

      try {
        const currentUser =
          await getCurrentProfile()

        user.value = currentUser

        return currentUser
      } catch (requestError) {
        clearAuthSession()
        throw requestError
      }
    }

    async function updateProfile(profile) {
      loading.value = true
      error.value = ''

      try {
        const updatedUser =
          await saveCurrentProfile({
            email:
              profile.email?.trim() || null,
            currency:
              profile.currency
          })

        user.value = updatedUser

        return updatedUser
      } catch (requestError) {
        error.value = getErrorMessage(
          requestError,
          'Unable to save profile changes.'
        )

        throw requestError
      } finally {
        loading.value = false
      }
    }

    async function logout() {
      clearAuthSession()
      error.value = ''

      await router.push('/login')
    }

    return {
      user,
      token,
      loading,
      error,
      isAuthenticated,
      login,
      register,
      fetchCurrentUser,
      updateProfile,
      logout,
      clearAuthSession
    }
  }
)