<template>
  <div class="auth-page grid-bg" style="position:relative;overflow:hidden;">
    <div class="glow glow-green" style="top:-100px;right:-100px;"></div>
    <div class="auth-card animate-in">
      <router-link to="/" class="auth-logo">
        <span class="logo-icon">&lt;/&gt;</span>
        <span>AiCodeHub</span>
      </router-link>
      <h2>欢迎回来</h2>
      <p class="auth-subtitle">登录你的账号继续使用</p>
      <el-form ref="formRef" :model="form" :rules="rules" @submit.prevent="handleLogin">
        <el-form-item prop="username">
          <el-input v-model="form.username" placeholder="用户名" size="large" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="form.password" type="password" placeholder="密码" size="large" show-password @keyup.enter="handleLogin" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" size="large" :loading="loading" @click="handleLogin" class="auth-btn">登录</el-button>
        </el-form-item>
      </el-form>
      <div class="auth-footer">还没有账号？<router-link to="/register">创建账号</router-link></div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/store/user'
import { login } from '@/api/user'
import { ElMessage } from 'element-plus'

const router = useRouter(), route = useRoute(), userStore = useUserStore()
const formRef = ref(null), loading = ref(false)
const form = reactive({ username: '', password: '' })
const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}
async function handleLogin() {
  try { await formRef.value.validate() } catch { return }
  loading.value = true
  try {
    const res = await login(form)
    userStore.setLogin(res.data)
    ElMessage.success('登录成功')
    router.push(route.query.redirect || '/dashboard')
  } catch {} finally { loading.value = false }
}
</script>

<style scoped>
.auth-page { min-height: 100vh; display: flex; align-items: center; justify-content: center; }
.auth-card { width: 400px; max-width: 100%; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-xl); padding: 48px 40px; box-shadow: var(--shadow-lg); }
.auth-logo { display: flex; align-items: center; gap: 6px; font-size: 17px; font-weight: 700; color: var(--text); margin-bottom: 28px; }
.logo-icon { color: var(--primary); }
.auth-card h2 { font-size: 24px; font-weight: 700; margin-bottom: 6px; letter-spacing: -0.02em; }
.auth-subtitle { color: var(--text2); font-size: 14px; margin-bottom: 28px; }
.auth-btn { width: 100%; height: 44px; border-radius: 9999px !important; font-size: 15px; font-weight: 500; }
.auth-footer { text-align: center; margin-top: 16px; font-size: 14px; color: var(--text2); }
.auth-footer a { color: var(--primary); font-weight: 500; }
</style>
