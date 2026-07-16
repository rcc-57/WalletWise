import apiClient from '@/api/client'

export async function getBills(type = null) {
  const params = {}

  if (type) {
    params.type = type
  }

  const response = await apiClient.get('/api/bills', {
    params
  })

  return response.data
}

export async function getBillById(id) {
  const response = await apiClient.get(`/api/bills/${id}`)
  return response.data
}

export async function createBill(bill) {
  const response = await apiClient.post('/api/bills', bill)
  return response.data
}

export async function updateBill(id, bill) {
  const response = await apiClient.put(`/api/bills/${id}`, bill)
  return response.data
}

export async function deleteBill(id) {
  await apiClient.delete(`/api/bills/${id}`)
}