<template>
  <div class="auth-page grid-bg" style="position:relative;overflow:hidden;">
    <div class="glow glow-purple" style="top:-100px;left:-100px;"></div>
    <div class="auth-card animate-in">
      <router-link to="/" class="auth-logo">
        <span class="logo-icon">&lt;/&gt;</span>
        <span>AiCodeHub</span>
      </router-link>
      <h2>创建账号</h2>
      <p class="auth-subtitle">加入开发者社区</p>
      <el-form ref="formRef" :model="form" :rules="rules" @submit.prevent="handleRegister">
        <el-form-item prop="username"><el-input v-model="form.username" placeholder="用户名（3-20字符）" size="large" /></el-form-item>
        <el-form-item prop="email"><el-input v-model="form.email" placeholder="邮箱地址" size="large" /></el-form-item>
        <el-form-item prop="password"><el-input v-model="form.password" type="password" placeholder="密码（6-30字符）" size="large" show-password /></el-form-item>
        <el-form-item prop="confirmPassword"><el-input v-model="form.confirmPassword" type="password" placeholder="确认密码" size="large" show-password @keyup.enter="handleRegister" /></el-form-item>
        <el-form-item><el-button type="primary" size="large" :loading="loading" @click="handleRegister" class="auth-btn">注册</el-button></el-form-item>
      </el-form>
      <div class="auth-footer">已有账号？<router-link to="/login">立即登录</router-link></div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { register } from '@/api/user'
import { ElMessage } from 'element-plus'

const router = useRouter()
const formRef = ref(null), loading = ref(false)
const form = reactive({ username: '', email: '', password: '', confirmPassword: '' })
const validateConfirm = (r, v, cb) => { if (v !== form.password) cb(new Error('两次密码不一致')); else cb() }
const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }, { min: 3, max: 20, message: '长度3-20', trigger: 'blur' }],
  email: [{ required: true, message: '请输入邮箱', trigger: 'blur' }, { type: 'email', message: '邮箱格式错误', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }, { min: 6, max: 30, message: '长度6-30', trigger: 'blur' }],
  confirmPassword: [{ required: true, message: '请确认密码', trigger: 'blur' }, { validator: validateConfirm, trigger: 'blur' }]
}
async function handleRegister() {
  try { await formRef.value.validate() } catch { return }
  loading.value = true
  try {
    await register({ username: form.username, email: form.email, password: form.password })
    ElMessage.success('注册成功，请登录')
    router.push('/login')
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
