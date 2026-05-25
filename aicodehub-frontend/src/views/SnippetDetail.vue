<template>
  <div class="detail-page">
    <!-- 导航 -->
    <header class="nav glass">
      <div class="nav-inner container-narrow">
        <router-link to="/" class="logo">
          <span class="logo-mark">&lt;/&gt;</span>
          <span class="logo-text">AiCodeHub</span>
        </router-link>
        <div class="nav-right">
          <button class="theme-toggle" @click="toggleTheme">{{ isDark ? '&#x2600;&#xFE0F;' : '&#x1F319;' }}</button>
          <router-link to="/explore" class="nav-link">探索</router-link>
          <router-link v-if="userStore.isLoggedIn()" to="/dashboard" class="nav-link">控制台</router-link>
          <router-link v-else to="/login" class="btn btn-ghost" style="padding: 6px 16px; font-size: 13px">登录</router-link>
        </div>
      </div>
    </header>

    <div class="container-narrow" style="padding-top: 80px; padding-bottom: 40px" v-if="snippet">
      <!-- 片段信息 -->
      <div class="card animate-in">
        <div class="detail-header">
          <div>
            <h1 class="detail-title">{{ snippet.title }}</h1>
            <p class="detail-desc" v-if="snippet.description">{{ snippet.description }}</p>
            <div class="detail-meta">
              <span class="lang-tag" :style="{ background: getLangColor(snippet.language) }">{{ snippet.language }}</span>
              <span>{{ snippet.authorName || '未知' }}</span>
              <span>{{ formatTime(snippet.createdAt) }}</span>
              <span>&#x1F441; {{ snippet.viewCount || 0 }}</span>
            </div>
          </div>
          <div class="detail-actions">
            <button class="btn" :class="isFavorited ? 'btn-primary' : 'btn-ghost'" @click="handleFavorite">
              {{ isFavorited ? '★ 已收藏' : '☆ 收藏' }} {{ snippet.likeCount || 0 }}
            </button>
            <template v-if="isOwner">
              <button class="btn btn-ghost" @click="$router.push(`/snippet/${snippet.id}/edit`)">编辑</button>
              <button class="btn btn-danger" @click="handleDelete" style="color: #fff">删除</button>
            </template>
          </div>
        </div>

        <!-- 代码区 -->
        <div class="code-block">
          <div class="code-block-header">
            <span>{{ snippet.language }}</span>
            <span class="copy-btn" @click="copyCode">复制代码</span>
          </div>
          <pre class="code-block-content"><code>{{ snippet.codeContent }}</code></pre>
        </div>
      </div>

      <!-- AI分析 -->
      <div class="card animate-in animate-in-delay-1" style="margin-top: 16px">
        <h3 class="section-label">&#x1F916; AI 分析</h3>
        <div class="ai-placeholder">
          <p>AI 代码分析功能将在第三阶段集成</p>
          <p style="font-size: 13px; color: var(--color-text-tertiary)">支持代码解释、优化建议、生成测试用例</p>
        </div>
      </div>

      <!-- 评论 -->
      <div class="card animate-in animate-in-delay-2" style="margin-top: 16px">
        <h3 class="section-label">&#x1F4AC; 评论 ({{ comments.length }})</h3>
        <div v-if="userStore.isLoggedIn()" style="margin-bottom: 20px">
          <el-input v-model="newComment" type="textarea" :rows="3" placeholder="写下你的评论..." />
          <el-button type="primary" @click="submitComment" :disabled="!newComment.trim()" style="margin-top: 8px; border-radius: 9999px">发表评论</el-button>
        </div>
        <div v-else style="margin-bottom: 16px; color: var(--color-text-secondary); font-size: 14px">
          <router-link to="/login">登录</router-link>后发表评论
        </div>
        <div v-for="comment in comments" :key="comment.id" class="comment-item">
          <div class="comment-header">
            <strong>{{ comment.userName || '匿名' }}</strong>
            <span>{{ formatTime(comment.createdAt) }}</span>
          </div>
          <p>{{ comment.content }}</p>
        </div>
        <div v-if="!comments.length" style="text-align: center; color: var(--color-text-tertiary); padding: 20px; font-size: 14px">暂无评论</div>
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

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const snippet = ref(null)
const comments = ref([])
const newComment = ref('')
const isFavorited = ref(false)
const isDark = ref(false)

const isOwner = computed(() => userStore.isLoggedIn() && snippet.value?.authorName === userStore.userInfo?.username)
const langColors = { java: '#ED8B00', python: '#3776AB', javascript: '#F7DF1E', typescript: '#3178C6', go: '#00ADD8', 'c++': '#00599C', rust: '#DEA584', sql: '#336791' }
function getLangColor(lang) { return langColors[lang?.toLowerCase()] || '#86868b' }
function formatTime(t) { return t ? new Date(t).toLocaleDateString() : '' }

function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.setAttribute('data-theme', isDark.value ? 'dark' : '')
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
  navigator.clipboard?.writeText(snippet.value.codeContent)
    .then(() => ElMessage.success('已复制'))
    .catch(() => {
      const ta = document.createElement('textarea')
      ta.value = snippet.value.codeContent
      document.body.appendChild(ta); ta.select(); document.execCommand('copy')
      document.body.removeChild(ta)
      ElMessage.success('已复制')
    })
}

onMounted(() => {
  loadData()
  isDark.value = localStorage.getItem('theme') === 'dark'
  if (isDark.value) document.documentElement.setAttribute('data-theme', 'dark')
})
</script>

<style scoped>
.detail-page { min-height: 100vh; }

.nav { position: fixed; top: 0; left: 0; right: 0; z-index: 100; padding: 10px 0; }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.logo { display: flex; align-items: center; gap: 6px; font-weight: 700; font-size: 17px; color: var(--color-text); }
.logo-mark { color: var(--color-primary); }
.nav-right { display: flex; align-items: center; gap: 16px; }
.nav-link { color: var(--color-text-secondary); font-size: 14px; }
.nav-link:hover { color: var(--color-primary); }
.theme-toggle { background: none; border: none; font-size: 16px; cursor: pointer; padding: 4px; }

.detail-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; gap: 16px; }
.detail-title { font-size: 22px; font-weight: 700; margin-bottom: 8px; letter-spacing: -0.02em; }
.detail-desc { font-size: 14px; color: var(--color-text-secondary); margin-bottom: 12px; line-height: 1.6; }
.detail-meta { display: flex; gap: 16px; align-items: center; font-size: 13px; color: var(--color-text-tertiary); }
.detail-actions { display: flex; gap: 8px; flex-shrink: 0; }

.section-label { font-size: 16px; font-weight: 600; margin-bottom: 16px; }
.ai-placeholder { background: var(--color-bg); border-radius: var(--radius-md); padding: 28px; text-align: center; color: var(--color-text-secondary); }

.copy-btn { cursor: pointer; color: var(--color-primary); transition: opacity 0.2s; }
.copy-btn:hover { opacity: 0.7; }

.comment-item { padding: 14px 0; border-bottom: 1px solid var(--color-border); }
.comment-item:last-child { border-bottom: none; }
.comment-header { display: flex; justify-content: space-between; margin-bottom: 6px; font-size: 14px; }
.comment-header span { color: var(--color-text-tertiary); font-size: 12px; }
.comment-item p { font-size: 14px; color: var(--color-text-secondary); line-height: 1.6; }
</style>
