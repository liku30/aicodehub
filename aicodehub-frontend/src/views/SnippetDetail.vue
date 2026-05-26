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
          <div class="code-block-body" v-html="highlightedCode"></div>
        </div>
      </div>

      <!-- 操作按钮 -->
      <div style="display:flex;gap:8px;margin-bottom:16px;">
        <button class="btn" :class="isFavorited ? 'btn-primary' : 'btn-ghost'" @click="handleFavorite">
          {{ isFavorited ? '★ 已收藏' : '☆ 收藏' }} {{ snippet.likeCount || 0 }}
        </button>
        <template v-if="isOwner">
          <button class="btn btn-ghost" @click="$router.push(`/snippet/${snippet.id}/edit`)">编辑</button>
          <button class="btn btn-danger" @click="handleDelete">删除</button>
        </template>
      </div>

      <!-- AI 分析（对话风格） -->
      <div class="card animate-in animate-d1">
        <h3 class="section-label">&#x1F916; AI 分析</h3>
        <div style="display:flex;gap:8px;margin-bottom:16px;">
          <span class="tab-tag active">代码解释</span>
          <span class="tab-tag">优化建议</span>
          <span class="tab-tag">生成测试</span>
        </div>
        <div class="ai-result-bubble">
          <div class="ai-avatar">&#x1F4A1;</div>
          <div class="ai-bubble-ai">
            <p><strong style="color:var(--text);">核心思想：</strong>这段代码实现了核心算法逻辑。使用<strong style="color:var(--primary);">高效的数据结构</strong>和<strong style="color:var(--primary);">优化的算法策略</strong>。</p>
            <p style="margin-top:8px;"><strong style="color:var(--text);">复杂度：</strong>时间 O(n log n)，空间 O(log n)。</p>
            <p style="margin-top:8px;"><strong style="color:var(--text);">适用场景：</strong>大规模数据处理，面试高频考点。</p>
          </div>
        </div>
        <div class="ai-result-bubble" style="margin-top:12px;">
          <div style="width:32px;height:32px;border-radius:50%;background:var(--surface2);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:14px;color:var(--text2);">你</div>
          <div class="ai-bubble-user">
            <p style="font-size:14px;color:var(--text2);">能否给出时间复杂度的推导过程？</p>
          </div>
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
import { ElMessage, ElMessageBox } from 'element-plus'
import hljs from 'highlight.js/lib/core'
import java from 'highlight.js/lib/languages/java'
import python from 'highlight.js/lib/languages/python'
import javascript from 'highlight.js/lib/languages/javascript'
import typescript from 'highlight.js/lib/languages/typescript'
import go from 'highlight.js/lib/languages/go'
import sql from 'highlight.js/lib/languages/sql'
import cpp from 'highlight.js/lib/languages/cpp'
import rust from 'highlight.js/lib/languages/rust'
import shell from 'highlight.js/lib/languages/shell'

// 注册语言
hljs.registerLanguage('java', java)
hljs.registerLanguage('python', python)
hljs.registerLanguage('javascript', javascript)
hljs.registerLanguage('typescript', typescript)
hljs.registerLanguage('go', go)
hljs.registerLanguage('sql', sql)
hljs.registerLanguage('cpp', cpp)
hljs.registerLanguage('rust', rust)
hljs.registerLanguage('shell', shell)

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const snippet = ref(null)
const comments = ref([])
const newComment = ref('')
const isFavorited = ref(false)
const isDark = ref(true)

const isOwner = computed(() => userStore.isLoggedIn() && snippet.value?.authorName === userStore.userInfo?.username)

const highlightedCode = computed(() => {
  if (!snippet.value?.codeContent) return ''
  const lang = snippet.value.language?.toLowerCase()
  const langMap = { 'c++': 'cpp', 'c/c++': 'cpp', 'shell': 'shell', 'bash': 'shell' }
  const mappedLang = langMap[lang] || lang
  try {
    if (hljs.getLanguage(mappedLang)) {
      return hljs.highlight(snippet.value.codeContent, { language: mappedLang }).value
    }
    return hljs.highlightAuto(snippet.value.codeContent).value
  } catch { return snippet.value.codeContent }
})

function formatTime(t) { return t ? new Date(t).toLocaleDateString() : '' }
function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.setAttribute('data-theme', isDark.value ? '' : 'light')
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
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
.tab-tag { display: inline-block; padding: 5px 14px; border-radius: 9999px; font-size: 13px; cursor: pointer; border: 1px solid var(--border); color: var(--text2); }
.tab-tag.active { background: var(--primary); color: #fff; border-color: var(--primary); }

.ai-result-bubble { display: flex; gap: 10px; }
.ai-avatar { width: 32px; height: 32px; border-radius: 50%; background: var(--gradient); display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-size: 16px; }
.ai-bubble-ai { background: var(--surface2); border-radius: 12px 12px 12px 0; padding: 14px 18px; border: 1px solid var(--border); flex: 1; }
.ai-bubble-user { background: var(--surface2); border-radius: 12px 12px 0 12px; padding: 14px 18px; border: 1px solid var(--border); flex: 1; }
.ai-bubble-ai p { font-size: 14px; color: var(--text2); line-height: 1.7; }

.lang-pill { display: inline-block; padding: 3px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; color: #fff; }

.comment-item { padding: 12px 0; border-bottom: 1px solid var(--border); }
.comment-item:last-child { border-bottom: none; }
.comment-meta { display: flex; justify-content: space-between; margin-bottom: 4px; }
.comment-meta strong { font-size: 14px; color: var(--text); }
.comment-meta span { font-size: 12px; color: var(--text3); }
.comment-body { font-size: 14px; color: var(--text2); line-height: 1.6; }
</style>
