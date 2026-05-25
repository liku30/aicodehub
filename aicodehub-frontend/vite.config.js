import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { fileURLToPath, URL } from 'node:url'

// Vite配置文件
export default defineConfig({
  plugins: [vue()],

  // 路径别名：@ → src目录
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },

  // 开发服务器配置
  server: {
    port: 5173,
    // 代理配置：前端请求 /api 开头的接口 → 转发到后端
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false,
        configure: (proxy) => {
          proxy.on('proxyReq', (proxyReq, req, res) => {
            console.log('[Proxy] →', req.method, req.url, '→ http://localhost:8080' + req.url)
          })
          proxy.on('proxyRes', (proxyRes, req, res) => {
            console.log('[Proxy] ←', proxyRes.statusCode, req.url)
          })
          proxy.on('error', (err, req, res) => {
            console.log('[Proxy] Error:', err.message)
          })
        }
      }
    }
  }
})
