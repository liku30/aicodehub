import request from './index'

/** 评论相关API */

export function getComments(snippetId) {
  return request.get(`/comment/list/${snippetId}`)
}

export function addComment(data) {
  return request.post('/comment', data)
}

export function deleteComment(id) {
  return request.delete(`/comment/${id}`)
}
