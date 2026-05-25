<template>
  <div class="editor-page">
    <header class="nav glass">
      <div class="nav-inner container-narrow">
        <router-link to="/dashboard" class="nav-back">← 返回</router-link>
        <span class="page-title">{{ isEdit ? '编辑代码片段' : '新建代码片段' }}</span>
        <div></div>
      </div>
    </header>

    <div class="container-narrow" style="padding-top: 80px; padding-bottom: 40px">
      <div class="card animate-in">
        <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
          <el-form-item label="标题" prop="title">
            <el-input v-model="form.title" placeholder="给你的代码片段起个名字" size="large" />
          </el-form-item>
          <el-form-item label="描述">
            <el-input v-model="form.description" placeholder="简短描述这段代码的功能（可选）" />
          </el-form-item>
          <div class="form-row">
            <el-form-item label="编程语言" prop="language" style="flex: 1">
              <el-select v-model="form.language" placeholder="选择语言" size="large" style="width: 100%">
                <el-option v-for="l in languages" :key="l" :label="l" :value="l" />
              </el-select>
            </el-form-item>
            <el-form-item label="可见性" style="flex: 1">
              <el-select v-model="form.visibility" size="large" style="width: 100%">
                <el-option label="公开" :value="1" />
                <el-option label="私有" :value="0" />
              </el-select>
            </el-form-item>
          </div>
          <el-form-item label="代码内容" prop="codeContent">
            <el-input v-model="form.codeContent" type="textarea" :rows="16" placeholder="在此粘贴或输入你的代码..." class="code-input" />
          </el-form-item>
          <div class="form-actions">
            <button type="button" class="btn btn-ghost" @click="$router.back()">取消</button>
            <el-button type="primary" :loading="loading" @click="handleSubmit" class="btn btn-primary submit-btn">{{ isEdit ? '保存修改' : '创建片段' }}</el-button>
          </div>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { createSnippet, updateSnippet, getSnippetDetail } from '@/api/snippet'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const formRef = ref(null)
const loading = ref(false)
const isEdit = computed(() => !!route.params.id)
const form = reactive({ title: '', description: '', language: '', codeContent: '', visibility: 1 })
const languages = ['Java', 'Python', 'JavaScript', 'TypeScript', 'Go', 'C/C++', 'Rust', 'SQL', 'Shell', 'Other']
const rules = {
  title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
  language: [{ required: true, message: '请选择语言', trigger: 'change' }],
  codeContent: [{ required: true, message: '请输入代码', trigger: 'blur' }]
}

async function handleSubmit() {
  try { await formRef.value.validate() } catch { return }
  loading.value = true
  try {
    if (isEdit.value) { await updateSnippet(route.params.id, form); ElMessage.success('已保存') }
    else { await createSnippet(form); ElMessage.success('已创建') }
    router.push('/dashboard')
  } catch {} finally { loading.value = false }
}

onMounted(async () => {
  if (isEdit.value) {
    try {
      const r = await getSnippetDetail(route.params.id)
      Object.assign(form, { title: r.data.title, description: r.data.description, language: r.data.language, codeContent: r.data.codeContent, visibility: r.data.visibility })
    } catch { router.push('/dashboard') }
  }
})
</script>

<style scoped>
.editor-page { min-height: 100vh; }
.nav { position: fixed; top: 0; left: 0; right: 0; z-index: 100; padding: 10px 0; }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.nav-back { color: var(--color-primary); font-size: 14px; }
.page-title { font-size: 15px; font-weight: 600; }
.form-row { display: flex; gap: 16px; }
.form-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 8px; }
.submit-btn { border-radius: var(--radius-full) !important; padding: 8px 24px; }
:deep(.code-input textarea) { font-family: var(--font-mono); font-size: 14px; line-height: 1.6; }
</style>
