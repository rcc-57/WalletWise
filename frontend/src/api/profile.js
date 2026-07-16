import apiClient from '@/api/client'

export async function getCurrentProfile() {
  const response = await apiClient.get(
    '/api/auth/me'
  )

  return response.data
}

export async function saveCurrentProfile(
  profile
) {
  const response = await apiClient.put(
    '/api/auth/me',
    profile
  )

  return response.data
}