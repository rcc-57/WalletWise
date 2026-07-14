import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import { useRouter } from 'vue-router'
import apiClient from '@/api/client'

export const useAuthStore = defineStore('auth', () => {
  const router = useRouter()
  const user = ref(null)
  const token = ref(localStorage.getItem('walletwise_token') || '')
  const loading = ref(false)
  const error = ref('')

  const isAuthenticated = computed(() => Boolean(token.value))

  function setAuthSession(authData) {
    token.value = authData.token || ''
    user.value = authData.user || null

    if (token.value) {
      localStorage.setItem('walletwise_token', token.value)
    } else {
      localStorage.removeItem('walletwise_token')
    }
  }

  async function login(credentials) {
    loading.value = true
    error.value = ''

    try {
      const response = await apiClient.post('/api/auth/login', credentials)
      setAuthSession(response.data)
      await fetchCurrentUser()
      await router.push('/dashboard')
      return response.data
    } catch (err) {
      error.value = err.response?.data?.message || 'Unable to sign in right now.'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function register(credentials) {
    loading.value = true
    error.value = ''

    try {
      const response = await apiClient.post('/api/auth/register', credentials)
      setAuthSession(response.data)
      await fetchCurrentUser()
      await router.push('/dashboard')
      return response.data
    } catch (err) {
      error.value = err.response?.data?.message || 'Unable to create your account right now.'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchCurrentUser() {
    if (!token.value) {
      user.value = null
      return
    }

    try {
      const response = await apiClient.get('/api/auth/me')
      user.value = response.data
    } catch (err) {
      setAuthSession({ token: '', user: null })
      throw err
    }
  }

  function logout() {
    setAuthSession({ token: '', user: null })
    router.push('/login')
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
    logout
  }
})
