import { createRouter, createWebHistory } from 'vue-router'

/**
 * 路由配置
 *
 * 定义：哪个URL路径 → 显示哪个页面组件
 * 例如：访问 /login → 显示 Login.vue
 */
const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home.vue')
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/Register.vue')
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: () => import('@/views/Dashboard.vue'),
    meta: { requiresAuth: true }  // 需要登录才能访问
  },
  {
    path: '/explore',
    name: 'Explore',
    component: () => import('@/views/Explore.vue')
  },
  // 静态路由必须放在 :id 路由前面，否则 /snippet/new 会被 /snippet/:id 拦截
  {
    path: '/snippet/new',
    name: 'SnippetNew',
    component: () => import('@/views/SnippetEditor.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/snippet/:id(\\d+)',
    name: 'SnippetDetail',
    component: () => import('@/views/SnippetDetail.vue')
  },
  {
    path: '/snippet/:id(\\d+)/edit',
    name: 'SnippetEdit',
    component: () => import('@/views/SnippetEditor.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('@/views/Profile.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

/**
 * 路由守卫
 * 在每次跳转前检查：如果页面需要登录，但用户没登录 → 跳转到登录页
 */
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')

  // 简单检查token是否过期（JWT第二段是payload，包含exp字段）
  let tokenValid = false
  if (token) {
    try {
      const payload = JSON.parse(atob(token.split('.')[1]))
      tokenValid = payload.exp * 1000 > Date.now()
    } catch {
      tokenValid = false
    }
  }

  if (to.meta.requiresAuth && !tokenValid) {
    // 需要登录但没Token或Token过期 → 清除并跳转登录页
    if (token) {
      localStorage.removeItem('token')
      localStorage.removeItem('userInfo')
    }
    next({ path: '/login', query: { redirect: to.fullPath } })
  } else if ((to.path === '/login' || to.path === '/register') && tokenValid) {
    // 已登录还访问登录页 → 跳转Dashboard
    next({ path: '/dashboard' })
  } else {
    next()
  }
})

export default router
