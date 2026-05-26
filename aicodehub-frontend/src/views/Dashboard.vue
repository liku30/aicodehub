<template>
  <div class="dashboard-page">
    <header class="nav">
      <div class="nav-inner container">
        <router-link to="/" class="logo">
          <span class="logo-icon">&lt;/&gt;</span>
          <span>AiCodeHub</span>
        </router-link>
        <div class="nav-center">
          <router-link to="/dashboard" class="nav-link active">我的代码</router-link>
          <router-link to="/explore" class="nav-link">探索</router-link>
        </div>
        <div class="nav-right">
          <button class="theme-btn" @click="toggleTheme">{{ isDark ? '&#x2600;&#xFE0F;' : '&#x1F319;' }}</button>
          <router-link to="/snippet/new" class="btn btn-primary" style="padding:6px 16px;font-size:13px;">+ 新建</router-link>
          <el-dropdown @command="handleCommand" trigger="click">
            <div class="avatar-circle">{{ userStore.userInfo?.username?.charAt(0)?.toUpperCase() || 'U' }}</div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                <el-dropdown-item v-if="userStore.userInfo?.role === 1" command="admin">管理后台</el-dropdown-item>
                <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </header>

    <div class="main-layout container">
      <aside class="sidebar">
        <div class="sidebar-card card">
          <div class="sidebar-title">筛选</div>
          <div class="sidebar-item" :class="{ active: currentFilter === '' }" @click="currentFilter=''; currentLanguage=''; loadSnippets()">全部代码</div>
          <div class="sidebar-item" :class="{ active: currentFilter === 'favorites' }" @click="currentFilter='favorites'; loadFavorites()">我的收藏</div>
        </div>
        <div class="sidebar-card card">
          <div class="sidebar-title">语言分布</div>
          <div class="bar-chart">
            <div v-for="(lang, i) in topLanguages" :key="lang.name" class="bar-item">
              <div class="bar-fill" :style="{ height: lang.height + 'px', background: lang.color }"></div>
              <div class="bar-label">{{ lang.label }}</div>
            </div>
          </div>
        </div>
        <div class="sidebar-card card">
          <div class="sidebar-title">统计</div>
          <div style="display:flex;justify-content:space-around;text-align:center;">
            <div>
              <div style="font-size:20px;font-weight:700;color:var(--text);">{{ snippetCount }}</div>
              <div style="font-size:11px;color:var(--text3);">片段</div>
            </div>
            <div>
              <div style="font-size:20px;font-weight:700;color:var(--text);">{{ languages.length }}</div>
              <div style="font-size:11px;color:var(--text3);">语言</div>
            </div>
          </div>
        </div>
      </aside>

      <main class="content">
        <div class="search-wrap">
          <el-input v-model="keyword" placeholder="搜索代码片段..." size="large" clearable
                    @clear="loadSnippets" @keyup.enter="loadSnippets" />
        </div>

        <div v-if="loading" class="card" style="padding:40px;text-align:center;">
          <el-skeleton :rows="4" animated />
        </div>

        <div v-else-if="snippets.length" class="snippet-list">
          <div v-for="(snippet, index) in snippets" :key="snippet.id"
               class="card card-interactive animate-in"
               :style="{ animationDelay: index * 0.05 + 's', opacity: 0 }"
               @click="$router.push(`/snippet/${snippet.id}`)">
            <div class="snippet-top">
              <span class="lang-pill" :style="{ background: getLangColor(snippet.language) }">{{ snippet.language }}</span>
              <span style="font-size:12px;color:var(--text3);">{{ formatTime(snippet.createdAt) }}</span>
            </div>
            <h3 class="snippet-title">{{ snippet.title }}</h3>
            <p class="snippet-desc" v-if="snippet.description">{{ truncate(snippet.description, 80) }}</p>
            <div class="code-preview"><code>{{ snippet.codeContent?.substring(0, 180) }}{{ snippet.codeContent?.length > 180 ? '...' : '' }}</code></div>
            <div class="snippet-stats">
              <span>&#x2B50; {{ snippet.likeCount || 0 }}</span>
              <span>&#x1F4AC; {{ snippet.commentCount || 0 }}</span>
              <span>&#x1F441; {{ snippet.viewCount || 0 }}</span>
            </div>
          </div>
        </div>

        <div v-else class="card" style="text-align:center;padding:60px 20px;">
          <div style="font-size:48px;margin-bottom:16px;">&#x1F4E6;</div>
          <h3 style="margin-bottom:8px;">还没有代码片段</h3>
          <p style="color:var(--text2);margin-bottom:16px;">创建你的第一个代码片段</p>
          <router-link to="/snippet/new" class="btn btn-primary">创建片段</router-link>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/store/user'
import { getMySnippets, getMyFavorites } from '@/api/snippet'

const router = useRouter()
const userStore = useUserStore()
const snippets = ref([])
const loading = ref(true)
const keyword = ref('')
const currentFilter = ref('')
const currentLanguage = ref('')
const isDark = ref(true)
const snippetCount = ref(0)

const languages = ['Java', 'Python', 'JavaScript', 'TypeScript', 'Go', 'C++', 'Rust', 'SQL']
const langColors = { java:'#ED8B00', python:'#3776AB', javascript:'#F7DF1E', typescript:'#3178C6', go:'#00ADD8', 'c++':'#00599C', rust:'#DEA584', sql:'#336791' }

const topLanguages = [
  { name: 'Java', label: 'Java', height: 70, color: '#ED8B00' },
  { name: 'Python', label: 'Py', height: 50, color: '#3776AB' },
  { name: 'JavaScript', label: 'JS', height: 35, color: '#F7DF1E' },
  { name: 'Go', label: 'Go', height: 20, color: '#00ADD8' },
  { name: 'SQL', label: 'SQL', height: 15, color: '#336791' },
]

function getLangColor(lang) { return langColors[lang?.toLowerCase()] || '#666' }
function truncate(s, n) { return s?.length > n ? s.substring(0, n) + '...' : s }
function formatTime(t) {
  if (!t) return ''
  const d = new Date(t), now = new Date(), diff = Math.floor((now - d) / 86400000)
  if (diff === 0) return '今天'; if (diff === 1) return '昨天'
  if (diff < 30) return `${diff}天前`; return d.toLocaleDateString()
}
function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.setAttribute('data-theme', isDark.value ? '' : 'light')
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}
async function loadSnippets() {
  loading.value = true
  try {
    const params = { pageNum: 1, pageSize: 20 }
    if (keyword.value) params.keyword = keyword.value
    if (currentLanguage.value) params.language = currentLanguage.value
    const res = await getMySnippets(params)
    snippets.value = res.data || []
    snippetCount.value = snippets.value.length
  } finally { loading.value = false }
}
async function loadFavorites() {
  loading.value = true
  try {
    const res = await getMyFavorites({ pageNum: 1, pageSize: 20 })
    snippets.value = res.data || []
  } finally { loading.value = false }
}
function handleCommand(cmd) {
  if (cmd === 'profile') router.push('/profile')
  if (cmd === 'admin') router.push('/admin')
  if (cmd === 'logout') { userStore.logout(); router.push('/login') }
}
onMounted(() => {
  loadSnippets()
  const saved = localStorage.getItem('theme')
  if (saved === 'light') { isDark.value = false; document.documentElement.setAttribute('data-theme', 'light') }
})
</script>

<style scoped>
.dashboard-page { min-height: 100vh; }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.logo { display: flex; align-items: center; gap: 8px; font-size: 18px; font-weight: 700; color: var(--text); }
.logo-icon { color: var(--primary); font-size: 20px; }
.nav-center { display: flex; gap: 24px; }
.nav-right { display: flex; align-items: center; gap: 12px; }
.nav-link { color: var(--text2); font-size: 14px; font-weight: 500; }
.nav-link.active { color: var(--primary); }
.nav-link:hover { color: var(--text); }
.theme-btn { background: var(--primary-light); border: none; border-radius: 50%; width: 34px; height: 34px; display: flex; align-items: center; justify-content: center; cursor: pointer; font-size: 16px; }
.avatar-circle { width: 32px; height: 32px; border-radius: 50%; background: var(--gradient); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 600; cursor: pointer; }

.main-layout { display: flex; gap: 20px; padding-top: 20px; padding-bottom: 40px; }
.sidebar { width: 220px; flex-shrink: 0; }
.sidebar-card { padding: 16px; margin-bottom: 12px; }
.sidebar-title { font-size: 11px; color: var(--text3); font-weight: 600; text-transform: uppercase; letter-spacing: 0.08em; margin-bottom: 10px; }
.sidebar-item { padding: 7px 12px; border-radius: 6px; font-size: 13px; color: var(--text2); cursor: pointer; transition: all 0.15s; }
.sidebar-item:hover { background: var(--primary-light); color: var(--primary); }
.sidebar-item.active { background: var(--primary-light); color: var(--primary); font-weight: 500; }

.content { flex: 1; min-width: 0; }
.search-wrap { margin-bottom: 16px; }

.snippet-list { display: flex; flex-direction: column; gap: 12px; }
.snippet-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; }
.snippet-title { font-size: 16px; font-weight: 600; margin-bottom: 6px; color: var(--text); }
.snippet-desc { font-size: 13px; color: var(--text2); margin-bottom: 12px; line-height: 1.5; }
.snippet-stats { display: flex; gap: 16px; font-size: 13px; color: var(--text3); }

.lang-pill { display: inline-block; padding: 3px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; color: #fff; }

.bar-chart { display: flex; align-items: flex-end; gap: 6px; height: 90px; margin-top: 12px; }
.bar-item { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 3px; }
.bar-fill { width: 100%; border-radius: 3px 3px 0 0; opacity: 0.7; transition: opacity 0.2s; }
.bar-fill:hover { opacity: 1; }
.bar-label { font-size: 10px; color: var(--text3); }

@media (max-width: 768px) {
  .sidebar { display: none; }
}
</style>
