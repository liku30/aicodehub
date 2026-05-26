<template>
  <div class="explore-page">
    <header class="nav">
      <div class="nav-inner container">
        <router-link to="/" class="logo">
          <span class="logo-icon">&lt;/&gt;</span>
          <span>AiCodeHub</span>
        </router-link>
        <div class="nav-right">
          <button class="theme-btn" @click="toggleTheme">{{ isDark ? '&#x2600;&#xFE0F;' : '&#x1F319;' }}</button>
          <router-link to="/explore" class="nav-link active">探索</router-link>
          <router-link v-if="userStore.isLoggedIn()" to="/dashboard" class="nav-link">控制台</router-link>
          <router-link v-else to="/login" class="btn btn-ghost" style="padding:6px 16px;font-size:13px;">登录</router-link>
        </div>
      </div>
    </header>

    <div class="container" style="padding-top:100px;padding-bottom:40px;">
      <div class="animate-in" style="text-align:center;margin-bottom:36px;">
        <h1 style="font-size:32px;font-weight:700;letter-spacing:-0.02em;color:var(--text);">探索代码库</h1>
        <p style="color:var(--text2);margin-top:8px;">发现社区中优秀的代码片段</p>
      </div>

      <div class="animate-in animate-d1" style="display:flex;gap:12px;margin-bottom:24px;">
        <el-input v-model="keyword" placeholder="搜索代码片段..." size="large" clearable @clear="loadData" @keyup.enter="loadData" style="flex:1;" />
        <el-select v-model="language" placeholder="语言" clearable @change="loadData" size="large" style="width:150px;">
          <el-option v-for="l in languages" :key="l" :label="l" :value="l" />
        </el-select>
      </div>

      <div v-if="loading"><el-skeleton :rows="5" animated /></div>
      <div v-else-if="snippets.length" class="snippet-grid">
        <div v-for="(s, i) in snippets" :key="s.id" class="card card-interactive animate-in" :style="{ animationDelay: i * 0.05 + 's', opacity: 0 }" @click="$router.push(`/snippet/${s.id}`)">
          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
            <span class="lang-pill" :style="{ background: getLangColor(s.language) }">{{ s.language }}</span>
            <span style="font-size:12px;color:var(--text3);">{{ s.authorName }}</span>
          </div>
          <h3 style="font-size:16px;font-weight:600;margin-bottom:6px;color:var(--text);">{{ s.title }}</h3>
          <p style="font-size:13px;color:var(--text2);margin-bottom:12px;line-height:1.5;">{{ s.description?.substring(0, 60) }}{{ s.description?.length > 60 ? '...' : '' }}</p>
          <div class="code-preview"><code>{{ s.codeContent?.substring(0, 150) }}{{ s.codeContent?.length > 150 ? '...' : '' }}</code></div>
          <div style="display:flex;gap:16px;font-size:13px;color:var(--text3);">
            <span>&#x2B50; {{ s.likeCount || 0 }}</span>
            <span>&#x1F4AC; {{ s.commentCount || 0 }}</span>
            <span>{{ formatTime(s.createdAt) }}</span>
          </div>
        </div>
      </div>
      <div v-else class="card" style="text-align:center;padding:60px;">
        <div style="font-size:48px;margin-bottom:16px;">&#x1F50D;</div>
        <h3>暂无结果</h3>
        <p style="color:var(--text2);">尝试其他搜索关键词</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useUserStore } from '@/store/user'
import { exploreSnippets } from '@/api/snippet'

const userStore = useUserStore()
const snippets = ref([]), loading = ref(true), keyword = ref(''), language = ref(''), isDark = ref(true)
const languages = ['Java','Python','JavaScript','TypeScript','Go','C++','Rust','SQL']
const langColors = { java:'#ED8B00', python:'#3776AB', javascript:'#F7DF1E', typescript:'#3178C6', go:'#00ADD8', 'c++':'#00599C', rust:'#DEA584', sql:'#336791' }
function getLangColor(l) { return langColors[l?.toLowerCase()] || '#666' }
function formatTime(t) { if (!t) return ''; const d = Math.floor((new Date() - new Date(t)) / 86400000); return d === 0 ? '今天' : d < 30 ? d+'天前' : new Date(t).toLocaleDateString() }
function toggleTheme() { isDark.value = !isDark.value; document.documentElement.setAttribute('data-theme', isDark.value ? '' : 'light'); localStorage.setItem('theme', isDark.value ? 'dark' : 'light') }
async function loadData() { loading.value = true; try { const p = { pageNum: 1, pageSize: 20 }; if (keyword.value) p.keyword = keyword.value; if (language.value) p.language = language.value; const r = await exploreSnippets(p); snippets.value = r.data || [] } finally { loading.value = false } }
onMounted(() => { loadData(); const s = localStorage.getItem('theme'); if (s === 'light') { isDark.value = false; document.documentElement.setAttribute('data-theme', 'light') } })
</script>

<style scoped>
.explore-page { min-height: 100vh; }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.logo { display: flex; align-items: center; gap: 8px; font-size: 18px; font-weight: 700; color: var(--text); }
.logo-icon { color: var(--primary); }
.nav-right { display: flex; align-items: center; gap: 16px; }
.nav-link { color: var(--text2); font-size: 14px; }
.nav-link.active { color: var(--primary); }
.theme-btn { background: var(--primary-light); border: none; border-radius: 50%; width: 34px; height: 34px; display: flex; align-items: center; justify-content: center; cursor: pointer; font-size: 16px; }
.snippet-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 16px; }
.lang-pill { display: inline-block; padding: 3px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; color: #fff; }
</style>
