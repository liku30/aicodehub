<template>
  <div class="profile-page">
    <header class="nav glass">
      <div class="nav-inner container-narrow">
        <router-link to="/" class="logo">
          <span class="logo-mark">&lt;/&gt;</span>
          <span class="logo-text">AiCodeHub</span>
        </router-link>
        <div class="nav-right">
          <router-link to="/dashboard" class="nav-link">控制台</router-link>
          <router-link to="/explore" class="nav-link">探索</router-link>
        </div>
      </div>
    </header>
    <div class="container-narrow" style="padding-top: 100px; padding-bottom: 40px">
      <div class="card animate-in">
        <h2 style="font-size: 20px; font-weight: 700; margin-bottom: 24px; letter-spacing: -0.02em">个人设置</h2>
        <el-form :model="form" label-position="top" style="max-width: 480px">
          <el-form-item label="昵称"><el-input v-model="form.nickname" placeholder="设置你的昵称" /></el-form-item>
          <el-form-item label="个人简介"><el-input v-model="form.bio" type="textarea" :rows="3" placeholder="介绍一下自己..." /></el-form-item>
          <el-form-item label="GitHub"><el-input v-model="form.githubUrl" placeholder="https://github.com/yourname" /></el-form-item>
          <el-form-item><el-button type="primary" :loading="loading" @click="handleSave" class="save-btn">保存修改</el-button></el-form-item>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getProfile, updateProfile } from '@/api/user'
import { ElMessage } from 'element-plus'

const loading = ref(false)
const form = reactive({ nickname: '', bio: '', githubUrl: '' })

onMounted(async () => {
  try { const r = await getProfile(); form.nickname = r.data.nickname || ''; form.bio = r.data.bio || ''; form.githubUrl = r.data.githubUrl || '' } catch {}
})

async function handleSave() {
  loading.value = true
  try { await updateProfile(form); ElMessage.success('已保存') } catch {} finally { loading.value = false }
}
</script>

<style scoped>
.profile-page { min-height: 100vh; }
.nav { position: fixed; top: 0; left: 0; right: 0; z-index: 100; padding: 10px 0; }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.logo { display: flex; align-items: center; gap: 6px; font-weight: 700; font-size: 17px; color: var(--color-text); }
.logo-mark { color: var(--color-primary); }
.nav-right { display: flex; gap: 20px; }
.nav-link { color: var(--color-text-secondary); font-size: 14px; }
.save-btn { border-radius: var(--radius-full) !important; padding: 8px 24px; }
</style>
