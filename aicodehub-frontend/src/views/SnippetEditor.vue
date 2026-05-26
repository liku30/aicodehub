<template>
  <div class="editor-page">
    <header class="nav">
      <div class="nav-inner container-narrow">
        <router-link to="/dashboard" class="nav-back" style="color:var(--primary);font-size:14px;">← 返回</router-link>
        <span style="font-size:15px;font-weight:600;">{{ isEdit ? '编辑代码片段' : '新建代码片段' }}</span>
        <div></div>
      </div>
    </header>
    <div class="container-narrow" style="padding-top:80px;padding-bottom:40px;">
      <div class="card animate-in">
        <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
          <el-form-item label="标题" prop="title"><el-input v-model="form.title" placeholder="给你的代码片段起个名字" size="large" /></el-form-item>
          <el-form-item label="描述"><el-input v-model="form.description" placeholder="简短描述（可选）" /></el-form-item>
          <div style="display:flex;gap:16px;">
            <el-form-item label="编程语言" prop="language" style="flex:1"><el-select v-model="form.language" placeholder="选择语言" size="large" style="width:100%;"><el-option v-for="l in languages" :key="l" :label="l" :value="l" /></el-select></el-form-item>
            <el-form-item label="可见性" style="flex:1"><el-select v-model="form.visibility" size="large" style="width:100%;"><el-option label="公开" :value="1" /><el-option label="私有" :value="0" /></el-select></el-form-item>
          </div>
          <el-form-item label="代码内容" prop="codeContent"><el-input v-model="form.codeContent" type="textarea" :rows="16" placeholder="在此粘贴或输入你的代码..." style="--el-input-bg-color:var(--surface2);" /></el-form-item>
          <div style="display:flex;justify-content:flex-end;gap:12px;margin-top:8px;">
            <button class="btn btn-ghost" @click="$router.back()">取消</button>
            <el-button type="primary" :loading="loading" @click="handleSubmit" style="border-radius:9999px;padding:8px 24px;">{{ isEdit ? '保存' : '创建' }}</el-button>
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

const route = useRoute(), router = useRouter(), formRef = ref(null), loading = ref(false)
const isEdit = computed(() => !!route.params.id)
const form = reactive({ title:'', description:'', language:'', codeContent:'', visibility:1 })
const languages = ['Java','Python','JavaScript','TypeScript','Go','C/C++','Rust','SQL','Shell','Other']
const rules = { title:[{required:true,message:'请输入标题',trigger:'blur'}], language:[{required:true,message:'请选择语言',trigger:'change'}], codeContent:[{required:true,message:'请输入代码',trigger:'blur'}] }
async function handleSubmit() { try { await formRef.value.validate() } catch { return }; loading.value = true; try { if (isEdit.value) { await updateSnippet(route.params.id, form); ElMessage.success('已保存') } else { await createSnippet(form); ElMessage.success('已创建') }; router.push('/dashboard') } catch {} finally { loading.value = false } }
onMounted(async () => { if (isEdit.value) { try { const r = await getSnippetDetail(route.params.id); Object.assign(form, r.data) } catch { router.push('/dashboard') } } })
</script>

<style scoped>
.editor-page { min-height: 100vh; }
.nav { position: fixed; top: 0; left: 0; right: 0; z-index: 100; padding: 10px 0; background: rgba(17,17,17,0.85); backdrop-filter: blur(24px); border-bottom: 1px solid var(--border); }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
</style>
