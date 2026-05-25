import request from './index'

/** 标签相关API */

export function getTagList() {
  return request.get('/tag/list')
}

export function getHotTags() {
  return request.get('/tag/hot')
}

export function createTag(name, color) {
  return request.post('/tag', null, { params: { name, color } })
}
