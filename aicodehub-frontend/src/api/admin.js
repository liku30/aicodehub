import request from './index'

/** 管理员相关API */

export function getStats() {
  return request.get('/admin/stats')
}

export function getAllUsers() {
  return request.get('/admin/users')
}

export function getAllSnippets() {
  return request.get('/admin/snippets')
}

export function toggleUserStatus(id, status) {
  return request.put(`/admin/users/${id}/status`, { status })
}

export function deleteUser(id) {
  return request.delete(`/admin/users/${id}`)
}

export function deleteSnippet(id) {
  return request.delete(`/admin/snippets/${id}`)
}
