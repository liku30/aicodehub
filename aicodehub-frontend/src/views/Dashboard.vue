<template>
  <div class="dashboard">
    <!-- 顶部导航 -->
    <header class="nav glass">
      <div class="nav-inner container">
        <router-link to="/" class="logo">
          <span class="logo-mark">&lt;/&gt;</span>
          <span class="logo-text">AiCodeHub</span>
        </router-link>
        <div class="nav-center">
          <router-link to="/dashboard" class="nav-link active">我的代码</router-link>
          <router-link to="/explore" class="nav-link">探索</router-link>
        </div>
        <div class="nav-right">
          <button class="theme-toggle" @click="toggleTheme">{{ isDark ? '&#x2600;&#xFE0F;' : '&#x1F319;' }}</button>
          <router-link to="/snippet/new" class="btn btn-primary" style="padding: 6px 16px; font-size: 13px">+ 新建</router-link>
          <el-dropdown @command="handleCommand" trigger="click">
            <div class="avatar-btn">
              {{ userStore.userInfo?.username?.charAt(0)?.toUpperCase() || 'U' }}
            </div>
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

    <div class="main container">
      <!-- 侧边栏 -->
      <aside class="sidebar">
        <div class="sidebar-card card">
          <div class="sidebar-title">筛选</div>
          <div class="sidebar-item" :class="{ active: currentFilter === '' }" @click="currentFilter = ''; currentLanguage = ''; loadSnippets()">全部代码</div>
          <div class="sidebar-item" :class="{ active: currentFilter === 'favorites' }" @click="currentFilter = 'favorites'; loadFavorites()">我的收藏</div>
        </div>
        <div class="sidebar-card card">
          <div class="sidebar-title">语言</div>
          <div v-for="lang in languages" :key="lang" class="sidebar-item"
               :class="{ active: currentLanguage === lang }"
               @click="filterByLanguage(lang)">{{ lang }}</div>
        </div>
      </aside>

      <!-- 内容区 -->
      <main class="content">
        <!-- 搜索 -->
        <div class="search-wrap">
          <el-input v-model="keyword" placeholder="搜索代码片段..." size="large" clearable
                    @clear="loadSnippets" @keyup.enter="loadSnippets" />
        </div>

        <!-- 加载 -->
        <div v-if="loading" class="card" style="padding: 40px; text-align: center">
          <el-skeleton :rows="4" animated />
        </div>

        <!-- 片段列表 -->
        <div v-else-if="snippets.length" class="snippet-list">
          <div v-for="(snippet, index) in snippets" :key="snippet.id"
               class="snippet-card card card-interactive animate-in"
               :style="{ animationDelay: index * 0.05 + 's', opacity: 0 }"
               @click="$router.push(`/snippet/${snippet.id}`)">
            <div class="snippet-top">
              <span class="lang-tag" :style="{ background: getLangColor(snippet.language) }">{{ snippet.language }}</span>
              <span class="snippet-time">{{ formatTime(snippet.createdAt) }}</span>
            </div>
            <h3 class="snippet-title">{{ snippet.title }}</h3>
            <p class="snippet-desc" v-if="snippet.description">{{ truncateDesc(snippet.description) }}</p>
            <pre class="code-preview"><code>{{ snippet.codeContent?.substring(0, 180) }}{{ snippet.codeContent?.length > 180 ? '...' : '' }}</code></pre>
            <div class="snippet-stats">
              <span>&#x2B50; {{ snippet.likeCount || 0 }}</span>
              <span>&#x1F4AC; {{ snippet.commentCount || 0 }}</span>
              <span>&#x1F441; {{ snippet.viewCount || 0 }}</span>
            </div>
          </div>
        </div>

        <!-- 空状态 -->
        <div v-else class="empty-state card">
          <div class="empty-icon">&#x1F4E6;</div>
          <h3>还没有代码片段</h3>
          <p>创建你的第一个代码片段开始使用</p>
          <router-link to="/snippet/new" class="btn btn-primary" style="margin-top: 16px">创建片段</router-link>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
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
const isDark = ref(false)

const languages = ['Java', 'Python', 'JavaScript', 'TypeScript', 'Go', 'C++', 'Rust', 'SQL']
const langColors = { java: '#ED8B00', python: '#3776AB', javascript: '#F7DF1E', typescript: '#3178C6', go: '#00ADD8', 'c++': '#00599C', rust: '#DEA584', sql: '#336791' }
function getLangColor(lang) { return langColors[lang?.toLowerCase()] || '#86868b' }

function formatTime(time) {
  if (!time) return ''
  const d = new Date(time), now = new Date(), diff = Math.floor((now - d) / 86400000)
  if (diff === 0) return '今天'; if (diff === 1) return '昨天'
  if (diff < 30) return `${diff}天前`; return d.toLocaleDateString()
}

function truncateDesc(desc) {
  return desc?.length > 80 ? desc.substring(0, 80) + '...' : desc
}

async function loadSnippets() {
  loading.value = true
  try {
    const params = { pageNum: 1, pageSize: 20 }
    if (keyword.value) params.keyword = keyword.value
    if (currentLanguage.value) params.language = currentLanguage.value
    const res = await getMySnippets(params)
    snippets.value = res.data || []
  } finally { loading.value = false }
}

async function loadFavorites() {
  loading.value = true
  try {
    const res = await getMyFavorites({ pageNum: 1, pageSize: 20 })
    snippets.value = res.data || []
  } finally { loading.value = false }
}

function filterByLanguage(lang) {
  currentLanguage.value = currentLanguage.value === lang ? '' : lang
  currentFilter.value = ''
  loadSnippets()
}

function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.setAttribute('data-theme', isDark.value ? 'dark' : '')
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

function handleCommand(cmd) {
  if (cmd === 'profile') router.push('/profile')
  if (cmd === 'admin') router.push('/admin')
  if (cmd === 'logout') { userStore.logout(); router.push('/login') }
}

onMounted(() => {
  loadSnippets()
  isDark.value = localStorage.getItem('theme') === 'dark'
  if (isDark.value) document.documentElement.setAttribute('data-theme', 'dark')
})
</script>

<style scoped>
.dashboard { min-height: 100vh; }

.nav { position: fixed; top: 0; left: 0; right: 0; z-index: 100; padding: 10px 0; }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.logo { display: flex; align-items: center; gap: 6px; font-weight: 700; font-size: 17px; color: var(--color-text); }
.logo-mark { color: var(--color-primary); }
.nav-center { display: flex; gap: 24px; }
.nav-link { color: var(--color-text-secondary); font-size: 14px; font-weight: 500; transition: color 0.2s; }
.nav-link:hover, .nav-link.active { color: var(--color-primary); }
.nav-right { display: flex; align-items: center; gap: 10px; }
.theme-toggle { background: none; border: none; font-size: 16px; cursor: pointer; padding: 4px; }
.avatar-btn {
  width: 32px; height: 32px; border-radius: 50%;
  background: var(--gradient-primary); color: #fff;
  display: flex; align-items: center; justify-content: center;
  font-size: 14px; font-weight: 600; cursor: pointer;
}

.main { display: flex; gap: 24px; padding-top: 80px; padding-bottom: 40px; }

.sidebar { width: 200px; flex-shrink: 0; }
.sidebar-card { padding: 16px; margin-bottom: 12px; }
.sidebar-title { font-size: 12px; color: var(--color-text-tertiary); font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 8px; }
.sidebar-item {
  padding: 8px 12px; border-radius: var(--radius-sm);
  font-size: 14px; color: var(--color-text-secondary); cursor: pointer;
  transition: all 0.15s;
}
.sidebar-item:hover { background: var(--color-primary-light); color: var(--color-primary); }
.sidebar-item.active { background: var(--color-primary-light); color: var(--color-primary); font-weight: 500; }

.content { flex: 1; min-width: 0; }
.search-wrap { margin-bottom: 16px; }

.snippet-list { display: flex; flex-direction: column; gap: 12px; }
.snippet-card { padding: 20px; }
.snippet-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
.snippet-time { font-size: 12px; color: var(--color-text-tertiary); }
.snippet-title { font-size: 16px; font-weight: 600; margin-bottom: 6px; color: var(--color-text); }
.snippet-desc { font-size: 13px; color: var(--color-text-secondary); margin-bottom: 12px; line-height: 1.5; }
.snippet-stats { display: flex; gap: 16px; font-size: 13px; color: var(--color-text-tertiary); }

.empty-state { text-align: center; padding: 60px 20px; }
.empty-icon { font-size: 48px; margin-bottom: 16px; }
.empty-state h3 { font-size: 18px; font-weight: 600; margin-bottom: 8px; }
.empty-state p { color: var(--color-text-secondary); font-size: 14px; }

@media (max-width: 768px) {
  .sidebar { display: none; }
}
</style>
