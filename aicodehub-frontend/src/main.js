import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

import App from './App.vue'
import router from './router'
import './assets/styles/global.css'

const app = createApp(App)

// 注册Element Plus图标（只注册是函数的组件，排除版本号等非组件导出）
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  if (typeof component === 'object' || typeof component === 'function') {
    app.component(key, component)
  }
}

app.use(createPinia())
app.use(router)
app.use(ElementPlus)

app.mount('#app')
