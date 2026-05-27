<template>
  <div class="detail-page">
    <header class="nav">
      <div class="nav-inner container-narrow">
        <router-link to="/" class="logo">
          <span class="logo-icon">&lt;/&gt;</span>
          <span>AiCodeHub</span>
        </router-link>
        <div class="nav-right">
          <button class="theme-btn" @click="toggleTheme">{{ isDark ? '&#x2600;&#xFE0F;' : '&#x1F319;' }}</button>
          <router-link to="/explore" class="nav-link">探索</router-link>
          <router-link v-if="userStore.isLoggedIn()" to="/dashboard" class="nav-link">控制台</router-link>
        </div>
      </div>
    </header>

    <div class="container-narrow" style="padding-top:80px;padding-bottom:40px;" v-if="snippet">
      <!-- 代码信息 -->
      <div class="card animate-in">
        <h1 class="detail-title">{{ snippet.title }}</h1>
        <p class="detail-desc" v-if="snippet.description">{{ snippet.description }}</p>
        <div class="detail-meta">
          <span class="tab-tag active" style="padding:4px 12px;font-size:12px;">{{ snippet.language }}</span>
          <span>{{ snippet.authorName || '未知' }}</span>
          <span>&#x1F441; {{ snippet.viewCount || 0 }}</span>
        </div>

        <div class="code-block" style="margin-top:20px;">
          <div class="code-block-header">
            <span>{{ snippet.language }}</span>
            <span style="cursor:pointer;color:var(--primary);" @click="copyCode">复制代码</span>
          </div>
          <pre class="code-block-body"><code>{{ snippet.codeContent }}</code></pre>
        </div>
      </div>

      <!-- 操作按钮 -->
      <div style="display:flex;gap:8px;margin-bottom:16px;flex-wrap:wrap;">
        <button class="btn" :class="isFavorited ? 'btn-primary' : 'btn-ghost'" @click="handleFavorite">
          {{ isFavorited ? '★ 已收藏' : '☆ 收藏' }} {{ snippet.likeCount || 0 }}
        </button>
        <template v-if="isOwner">
          <button class="btn btn-ghost" @click="$router.push(`/snippet/${snippet.id}/edit`)">编辑</button>
          <button class="btn btn-danger" @click="handleDelete">删除</button>
        </template>
      </div>

      <!-- ===== AI 分析区 ===== -->
      <div class="card animate-in animate-d1">
        <h3 class="section-label">&#x1F916; AI 分析</h3>

        <!-- AI 功能 Tab -->
        <div class="ai-tabs-wrap">
          <span v-for="tab in aiTabs" :key="tab.key"
                class="tab-tag"
                :class="{ active: activeAiTab === tab.key }"
                @click="switchAiTab(tab.key)">
            {{ tab.icon }} {{ tab.label }}
          </span>
        </div>

        <!-- 翻译目标语言选择 -->
        <div v-if="activeAiTab === 'translate'" style="margin:12px 0;">
          <el-select v-model="targetLang" placeholder="选择目标语言" size="small" style="width:180px;">
            <el-option v-for="l in languages" :key="l" :label="l" :value="l" :disabled="l === snippet.language" />
          </el-select>
        </div>

        <!-- AI 结果展示 -->
        <div v-if="aiLoading || aiResult" class="ai-result-area">
          <div class="ai-result-bubble">
            <div class="ai-avatar">&#x1F4A1;</div>
            <div class="ai-bubble-ai">
              <!-- 加载中 -->
              <div v-if="aiLoading && !aiResult" class="ai-loading">
                <span class="ai-dots"><i></i><i></i><i></i></span>
                <span>AI 正在分析中...</span>
              </div>
              <!-- 结果 -->
              <div v-if="aiResult" class="ai-result-text" v-html="formatAiResult(aiResult)"></div>
              <!-- 流式光标 -->
              <span v-if="aiStreaming" class="ai-cursor">|</span>
            </div>
          </div>
        </div>

        <!-- 未调用时的提示 -->
        <div v-if="!aiLoading && !aiResult" class="ai-hint">
          <p>点击上方 Tab 对当前代码进行 AI 分析</p>
        </div>

        <!-- 重新分析按钮 -->
        <div v-if="aiResult && !aiLoading" style="margin-top:12px;">
          <button class="btn btn-ghost btn-sm" @click="runAiAnalysis">重新分析</button>
        </div>
      </div>

      <!-- 评论 -->
      <div class="card animate-in animate-d2">
        <h3 class="section-label">&#x1F4AC; 评论 ({{ comments.length }})</h3>
        <div v-if="userStore.isLoggedIn()" style="margin-bottom:20px;">
          <el-input v-model="newComment" type="textarea" :rows="3" placeholder="写下你的评论..." />
          <el-button type="primary" @click="submitComment" :disabled="!newComment.trim()" style="margin-top:8px;border-radius:9999px;">发表评论</el-button>
        </div>
        <div v-else style="margin-bottom:16px;color:var(--text2);font-size:14px;">
          <router-link to="/login">登录</router-link>后发表评论
        </div>
        <div v-for="comment in comments" :key="comment.id" class="comment-item">
          <div class="comment-meta">
            <strong>{{ comment.userName || '匿名' }}</strong>
            <span>{{ formatTime(comment.createdAt) }}</span>
          </div>
          <p class="comment-body">{{ comment.content }}</p>
        </div>
        <div v-if="!comments.length" style="text-align:center;color:var(--text3);padding:20px;font-size:14px;">暂无评论</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/store/user'
import { getSnippetDetail, deleteSnippet, toggleFavorite } from '@/api/snippet'
import { getComments, addComment } from '@/api/comment'
import { aiExplainStream, aiOptimizeStream, aiTestStream, aiTranslateStream, aiDocStream, aiReviewStream } from '@/api/ai'
import { ElMessage, ElMessageBox } from 'element-plus'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const snippet = ref(null)
const comments = ref([])
const newComment = ref('')
const isFavorited = ref(false)
const isDark = ref(true)

// AI 相关状态
const activeAiTab = ref('explain')
const aiResult = ref('')
const aiLoading = ref(false)
const aiStreaming = ref(false)
const targetLang = ref('Python')

const languages = ['Java', 'Python', 'JavaScript', 'TypeScript', 'Go', 'C/C++', 'Rust', 'SQL', 'Shell']

const aiTabs = [
  { key: 'explain', label: '代码解释', icon: '💡' },
  { key: 'optimize', label: '优化建议', icon: '⚡' },
  { key: 'test', label: '生成测试', icon: '🧪' },
  { key: 'translate', label: '代码翻译', icon: '🔄' },
  { key: 'doc', label: '生成文档', icon: '📝' },
  { key: 'review', label: '代码审查', icon: '🔍' },
]

const isOwner = computed(() => userStore.isLoggedIn() && snippet.value?.authorName === userStore.userInfo?.username)

function formatTime(t) { return t ? new Date(t).toLocaleDateString() : '' }

function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.setAttribute('data-theme', isDark.value ? '' : 'light')
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

// 切换 AI Tab
function switchAiTab(tab) {
  activeAiTab.value = tab
  aiResult.value = ''
  runAiAnalysis()
}

// 执行 AI 分析（SSE 流式）
function runAiAnalysis() {
  if (!snippet.value?.codeContent) return
  if (!userStore.isLoggedIn()) {
    ElMessage.warning('请先登录后使用 AI 功能')
    router.push('/login')
    return
  }

  aiResult.value = ''
  aiLoading.value = true
  aiStreaming.value = false

  const data = {
    code: snippet.value.codeContent,
    language: snippet.value.language || 'Java'
  }

  const onChunk = (chunk) => {
    if (!aiStreaming.value) {
      aiLoading.value = false
      aiStreaming.value = true
    }
    aiResult.value += chunk
  }

  const onDone = () => {
    aiLoading.value = false
    aiStreaming.value = false
  }

  const onError = (err) => {
    aiLoading.value = false
    aiStreaming.value = false
    if (!aiResult.value) {
      aiResult.value = 'AI 分析失败，请稍后再试。'
    }
    console.error('AI 分析错误:', err)
  }

  switch (activeAiTab.value) {
    case 'explain':
      aiExplainStream(data, onChunk, onDone, onError)
      break
    case 'optimize':
      aiOptimizeStream(data, onChunk, onDone, onError)
      break
    case 'test':
      aiTestStream(data, onChunk, onDone, onError)
      break
    case 'translate':
      aiTranslateStream({ ...data, toLang: targetLang.value }, onChunk, onDone, onError)
      break
    case 'doc':
      aiDocStream(data, onChunk, onDone, onError)
      break
    case 'review':
      aiReviewStream(data, onChunk, onDone, onError)
      break
  }
}

// 格式化 AI 结果（简单的换行和代码块处理）
function formatAiResult(text) {
  if (!text) return ''
  // 转义HTML
  let html = text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
  // 代码块 ```...```
  html = html.replace(/```(\w*)\n?([\s\S]*?)```/g, '<pre class="ai-code">$2</pre>')
  // 行内代码 `...`
  html = html.replace(/`([^`]+)`/g, '<code class="ai-inline-code">$1</code>')
  // 加粗 **...**
  html = html.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
  // 换行
  html = html.replace(/\n/g, '<br>')
  return html
}

async function loadData() {
  try { const r = await getSnippetDetail(route.params.id); snippet.value = r.data } catch { router.push('/explore') }
  try { const r = await getComments(route.params.id); comments.value = r.data || [] } catch {}
}

async function handleFavorite() {
  if (!userStore.isLoggedIn()) { router.push('/login'); return }
  try {
    const r = await toggleFavorite(snippet.value.id)
    isFavorited.value = r.data
    snippet.value.likeCount += isFavorited.value ? 1 : -1
    ElMessage.success(r.message)
  } catch {}
}

async function handleDelete() {
  try { await ElMessageBox.confirm('确定删除？', '提示', { type: 'warning' }) } catch { return }
  try { await deleteSnippet(snippet.value.id); ElMessage.success('已删除'); router.push('/dashboard') } catch {}
}

async function submitComment() {
  if (!newComment.value.trim()) return
  try { await addComment({ snippetId: snippet.value.id, content: newComment.value }); ElMessage.success('评论成功'); newComment.value = ''; loadData() } catch {}
}

function copyCode() {
  const text = snippet.value?.codeContent || ''
  navigator.clipboard?.writeText(text).then(() => ElMessage.success('已复制')).catch(() => {
    const ta = document.createElement('textarea'); ta.value = text; document.body.appendChild(ta)
    ta.select(); document.execCommand('copy'); document.body.removeChild(ta); ElMessage.success('已复制')
  })
}

onMounted(() => {
  loadData()
  const saved = localStorage.getItem('theme')
  if (saved === 'light') { isDark.value = false; document.documentElement.setAttribute('data-theme', 'light') }
})
</script>

<style scoped>
.detail-page { min-height: 100vh; }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.logo { display: flex; align-items: center; gap: 8px; font-size: 18px; font-weight: 700; color: var(--text); }
.logo-icon { color: var(--primary); font-size: 20px; }
.nav-right { display: flex; align-items: center; gap: 16px; }
.nav-link { color: var(--text2); font-size: 14px; }
.nav-link:hover { color: var(--text); }
.theme-btn { background: var(--primary-light); border: none; border-radius: 50%; width: 34px; height: 34px; display: flex; align-items: center; justify-content: center; cursor: pointer; font-size: 16px; }

.detail-title { font-size: 22px; font-weight: 700; margin-bottom: 8px; color: var(--text); letter-spacing: -0.02em; }
.detail-desc { font-size: 14px; color: var(--text2); margin-bottom: 12px; line-height: 1.6; }
.detail-meta { display: flex; gap: 12px; align-items: center; font-size: 13px; color: var(--text3); }
.section-label { font-size: 16px; font-weight: 600; margin-bottom: 16px; color: var(--text); }
.tab-tag { display: inline-block; padding: 5px 14px; border-radius: 9999px; font-size: 13px; cursor: pointer; border: 1px solid var(--border); color: var(--text2); transition: all 0.15s; }
.tab-tag.active { background: var(--primary); color: #fff; border-color: var(--primary); }
.tab-tag:hover { border-color: var(--primary); }
.btn-sm { padding: 6px 16px; font-size: 13px; }

/* AI Tabs */
.ai-tabs-wrap { display: flex; gap: 6px; margin-bottom: 16px; flex-wrap: wrap; }

/* AI 结果区域 */
.ai-result-area { margin-top: 4px; }
.ai-result-bubble { display: flex; gap: 10px; }
.ai-avatar { width: 32px; height: 32px; border-radius: 50%; background: var(--gradient); display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 16px; }
.ai-bubble-ai { background: var(--surface2); border-radius: 12px 12px 12px 0; padding: 14px 18px; border: 1px solid var(--border); flex: 1; position: relative; min-height: 48px; }
.ai-result-text { font-size: 14px; color: var(--text2); line-height: 1.8; }
.ai-result-text :deep(strong) { color: var(--text); }
.ai-result-text :deep(.ai-code) { background: #1a1a1a; border: 1px solid var(--border); border-radius: 8px; padding: 12px; font-family: 'Fira Code', monospace; font-size: 13px; overflow-x: auto; margin: 8px 0; white-space: pre; }
.ai-result-text :deep(.ai-inline-code) { background: var(--surface); padding: 2px 6px; border-radius: 4px; font-family: 'Fira Code', monospace; font-size: 13px; }

/* 加载动画 */
.ai-loading { display: flex; align-items: center; gap: 8px; font-size: 14px; color: var(--text2); }
.ai-dots { display: flex; gap: 4px; }
.ai-dots i { width: 6px; height: 6px; border-radius: 50%; background: var(--primary); animation: dotPulse 1.4s infinite; }
.ai-dots i:nth-child(2) { animation-delay: 0.2s; }
.ai-dots i:nth-child(3) { animation-delay: 0.4s; }
@keyframes dotPulse { 0%, 80%, 100% { opacity: 0.3; transform: scale(0.8); } 40% { opacity: 1; transform: scale(1); } }

/* 流式光标 */
.ai-cursor { animation: blink 1s infinite; color: var(--primary); font-weight: bold; }
@keyframes blink { 50% { opacity: 0; } }

/* 提示 */
.ai-hint { text-align: center; padding: 24px; color: var(--text3); font-size: 14px; }

/* 评论 */
.comment-item { padding: 12px 0; border-bottom: 1px solid var(--border); }
.comment-item:last-child { border-bottom: none; }
.comment-meta { display: flex; justify-content: space-between; margin-bottom: 4px; }
.comment-meta strong { font-size: 14px; color: var(--text); }
.comment-meta span { font-size: 12px; color: var(--text3); }
.comment-body { font-size: 14px; color: var(--text2); line-height: 1.6; }
</style>
