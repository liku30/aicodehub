import request from './index'

/**
 * AI 分析 API
 * 支持普通请求和 SSE 流式请求
 */

// 普通请求（一次性返回）
export function aiExplain(data) {
  return request.post('/ai/explain', data)
}

export function aiOptimize(data) {
  return request.post('/ai/optimize', data)
}

export function aiTest(data) {
  return request.post('/ai/test', data)
}

export function aiTranslate(data) {
  return request.post('/ai/translate', data)
}

export function aiDoc(data) {
  return request.post('/ai/doc', data)
}

export function aiReview(data) {
  return request.post('/ai/review', data)
}

/**
 * SSE 流式请求
 * 使用 Fetch API 逐块读取响应
 *
 * @param {string} endpoint - 接口路径，如 '/ai/explain/stream'
 * @param {object} data - 请求体 { code, language, toLang? }
 * @param {function} onChunk - 每收到一块数据时的回调
 * @param {function} onDone - 流结束时的回调
 * @param {function} onError - 出错时的回调
 */
export function aiStream(endpoint, data, onChunk, onDone, onError) {
  const token = localStorage.getItem('token')
  const baseURL = request.defaults.baseURL

  fetch(baseURL + endpoint, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': token ? `Bearer ${token}` : ''
    },
    body: JSON.stringify(data)
  })
  .then(response => {
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`)
    }
    const reader = response.body.getReader()
    const decoder = new TextDecoder()

    function read() {
      reader.read().then(({ done, value }) => {
        if (done) {
          onDone && onDone()
          return
        }
        const text = decoder.decode(value, { stream: true })
        // SSE 格式: data: xxx\n\n
        const lines = text.split('\n')
        for (const line of lines) {
          if (line.startsWith('data:')) {
            const content = line.substring(5).trim()
            if (content) {
              onChunk && onChunk(content)
            }
          }
        }
        read()
      }).catch(err => {
        onError && onError(err)
      })
    }
    read()
  })
  .catch(err => {
    onError && onError(err)
  })
}

// 各功能的流式快捷方法
export function aiExplainStream(data, onChunk, onDone, onError) {
  return aiStream('/ai/explain/stream', data, onChunk, onDone, onError)
}

export function aiOptimizeStream(data, onChunk, onDone, onError) {
  return aiStream('/ai/optimize/stream', data, onChunk, onDone, onError)
}

export function aiTestStream(data, onChunk, onDone, onError) {
  return aiStream('/ai/test/stream', data, onChunk, onDone, onError)
}

export function aiTranslateStream(data, onChunk, onDone, onError) {
  return aiStream('/ai/translate/stream', data, onChunk, onDone, onError)
}

export function aiDocStream(data, onChunk, onDone, onError) {
  return aiStream('/ai/doc/stream', data, onChunk, onDone, onError)
}

export function aiReviewStream(data, onChunk, onDone, onError) {
  return aiStream('/ai/review/stream', data, onChunk, onDone, onError)
}
