import request from './index'

/** 代码片段相关API */

// 创建片段
export function createSnippet(data) {
  return request.post('/snippet', data)
}

// 获取片段详情
export function getSnippetDetail(id) {
  return request.get(`/snippet/${id}`)
}

// 修改片段
export function updateSnippet(id, data) {
  return request.put(`/snippet/${id}`, data)
}

// 删除片段
export function deleteSnippet(id) {
  return request.delete(`/snippet/${id}`)
}

// 获取我的片段
export function getMySnippets(params) {
  return request.get('/snippet/my', { params })
}

// 探索广场（公开片段）
export function exploreSnippets(params) {
  return request.get('/snippet/explore', { params })
}

// 收藏/取消收藏
export function toggleFavorite(id) {
  return request.post(`/snippet/${id}/favorite`)
}

// 我的收藏
export function getMyFavorites(params) {
  return request.get('/snippet/favorites', { params })
}
