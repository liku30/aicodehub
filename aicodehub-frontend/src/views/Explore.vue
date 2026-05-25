<template>
  <div class="explore-page">
    <header class="nav glass">
      <div class="nav-inner container">
        <router-link to="/" class="logo">
          <span class="logo-mark">&lt;/&gt;</span>
          <span class="logo-text">AiCodeHub</span>
        </router-link>
        <div class="nav-right">
          <button class="theme-toggle" @click="toggleTheme">{{ isDark ? '&#x2600;&#xFE0F;' : '&#x1F319;' }}</button>
          <router-link to="/explore" class="nav-link active">探索</router-link>
          <router-link v-if="userStore.isLoggedIn()" to="/dashboard" class="nav-link">控制台</router-link>
          <router-link v-else to="/login" class="btn btn-ghost" style="padding: 6px 16px; font-size: 13px">登录</router-link>
        </div>
      </div>
    </header>

    <div class="container" style="padding-top: 100px; padding-bottom: 40px">
      <div class="explore-header animate-in">
        <h1>探索代码库</h1>
        <p>发现社区中优秀的代码片段</p>
      </div>

      <div class="filter-bar animate-in animate-in-delay-1">
        <el-input v-model="keyword" placeholder="搜索代码片段..." size="large" clearable @clear="loadData" @keyup.enter="loadData" style="flex: 1" />
        <el-select v-model="language" placeholder="语言" clearable @change="loadData" size="large" style="width: 150px">
          <el-option v-for="l in languages" :key="l" :label="l" :value="l" />
        </el-select>
      </div>

      <div v-if="loading"><el-skeleton :rows="5" animated /></div>
      <div v-else-if="snippets.length" class="snippet-grid">
        <div v-for="(s, i) in snippets" :key="s.id"
             class="snippet-card card card-interactive animate-in"
             :style="{ animationDelay: i * 0.05 + 's', opacity: 0 }"
             @click="$router.push(`/snippet/${s.id}`)">
          <div class="snippet-top">
            <span class="lang-tag" :style="{ background: getLangColor(s.language) }">{{ s.language }}</span>
            <span class="snippet-author">{{ s.authorName }}</span>
          </div>
          <h3>{{ s.title }}</h3>
          <p class="snippet-desc" v-if="s.description">{{ s.description?.substring(0, 60) }}{{ s.description?.length > 60 ? '...' : '' }}</p>
          <pre class="code-preview"><code>{{ s.codeContent?.substring(0, 150) }}{{ s.codeContent?.length > 150 ? '...' : '' }}</code></pre>
          <div class="snippet-stats">
            <span>&#x2B50; {{ s.likeCount || 0 }}</span>
            <span>&#x1F4AC; {{ s.commentCount || 0 }}</span>
            <span>{{ formatTime(s.createdAt) }}</span>
          </div>
        </div>
      </div>
      <div v-else class="empty-state card">
        <div class="empty-icon">&#x1F50D;</div>
        <h3>暂无结果</h3>
        <p>尝试其他搜索关键词或语言</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useUserStore } from '@/store/user'
import { exploreSnippets } from '@/api/snippet'

const userStore = useUserStore()
const snippets = ref([])
const loading = ref(true)
const keyword = ref('')
const language = ref('')
const isDark = ref(false)
const languages = ['Java', 'Python', 'JavaScript', 'TypeScript', 'Go', 'C++', 'Rust', 'SQL']
const langColors = { java: '#ED8B00', python: '#3776AB', javascript: '#F7DF1E', typescript: '#3178C6', go: '#00ADD8', 'c++': '#00599C', rust: '#DEA584', sql: '#336791' }
function getLangColor(lang) { return langColors[lang?.toLowerCase()] || '#86868b' }
function formatTime(t) { return t ? new Date(t).toLocaleDateString() : '' }

function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.setAttribute('data-theme', isDark.value ? 'dark' : '')
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

async function loadData() {
  loading.value = true
  try {
    const params = { pageNum: 1, pageSize: 20 }
    if (keyword.value) params.keyword = keyword.value
    if (language.value) params.language = language.value
    const res = await exploreSnippets(params)
    snippets.value = res.data || []
  } finally { loading.value = false }
}

onMounted(() => {
  loadData()
  isDark.value = localStorage.getItem('theme') === 'dark'
  if (isDark.value) document.documentElement.setAttribute('data-theme', 'dark')
})
</script>

<style scoped>
.explore-page { min-height: 100vh; }
.nav { position: fixed; top: 0; left: 0; right: 0; z-index: 100; padding: 10px 0; }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.logo { display: flex; align-items: center; gap: 6px; font-weight: 700; font-size: 17px; color: var(--color-text); }
.logo-mark { color: var(--color-primary); }
.nav-right { display: flex; align-items: center; gap: 16px; }
.nav-link { color: var(--color-text-secondary); font-size: 14px; }
.nav-link:hover, .nav-link.active { color: var(--color-primary); }
.theme-toggle { background: none; border: none; font-size: 16px; cursor: pointer; padding: 4px; }

.explore-header { text-align: center; margin-bottom: 36px; }
.explore-header h1 { font-size: 32px; font-weight: 700; letter-spacing: -0.02em; margin-bottom: 8px; }
.explore-header p { color: var(--color-text-secondary); font-size: 16px; }

.filter-bar { display: flex; gap: 12px; margin-bottom: 24px; }
.snippet-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 16px; }
.snippet-card { padding: 20px; }
.snippet-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
.snippet-author { font-size: 13px; color: var(--color-text-tertiary); }
.snippet-card h3 { font-size: 16px; font-weight: 600; margin-bottom: 6px; }
.snippet-desc { font-size: 13px; color: var(--color-text-secondary); margin-bottom: 12px; line-height: 1.5; }
.snippet-stats { display: flex; gap: 16px; font-size: 13px; color: var(--color-text-tertiary); }
.empty-state { text-align: center; padding: 60px 20px; }
.empty-icon { font-size: 48px; margin-bottom: 16px; }
.empty-state h3 { font-size: 18px; font-weight: 600; margin-bottom: 8px; }
.empty-state p { color: var(--color-text-secondary); font-size: 14px; }
</style>
