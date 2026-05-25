import { defineStore } from 'pinia'
import { ref } from 'vue'

/**
 * 用户状态管理（Pinia Store）
 *
 * 作用：在全局范围内管理用户登录状态
 * 任何组件都可以通过 useUserStore() 访问和修改用户状态
 */
export const useUserStore = defineStore('user', () => {
  // 状态
  const token = ref(localStorage.getItem('token') || '')
  const userInfo = ref(JSON.parse(localStorage.getItem('userInfo') || 'null'))

  // 登录成功后调用
  function setLogin(data) {
    token.value = data.token
    userInfo.value = {
      userId: data.userId,
      username: data.username,
      nickname: data.nickname,
      avatar: data.avatar,
      role: data.role
    }
    // 持久化到localStorage（刷新页面后仍能保持登录状态）
    localStorage.setItem('token', data.token)
    localStorage.setItem('userInfo', JSON.stringify(userInfo.value))
  }

  // 退出登录
  function logout() {
    token.value = ''
    userInfo.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
  }

  // 是否已登录
  const isLoggedIn = () => !!token.value

  return { token, userInfo, setLogin, logout, isLoggedIn }
})
