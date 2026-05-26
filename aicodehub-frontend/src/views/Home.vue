<template>
  <div class="home grid-bg" style="position:relative;overflow:hidden;">
    <!-- 背景光晕 -->
    <div class="glow glow-green" style="top:-200px;left:-100px;"></div>
    <div class="glow glow-purple" style="top:100px;right:-200px;"></div>

    <!-- 导航 -->
    <header class="nav">
      <div class="nav-inner container">
        <router-link to="/" class="logo">
          <span class="logo-icon">&lt;/&gt;</span>
          <span>AiCodeHub</span>
        </router-link>
        <div class="nav-right">
          <router-link to="/explore" class="nav-link">探索</router-link>
          <button class="theme-btn" @click="toggleTheme" :title="isDark ? '切换亮色' : '切换暗色'">
            {{ isDark ? '&#x2600;&#xFE0F;' : '&#x1F319;' }}
          </button>
          <template v-if="userStore.isLoggedIn()">
            <router-link to="/dashboard" class="btn btn-primary btn-pill">控制台</router-link>
          </template>
          <template v-else>
            <router-link to="/login" class="btn btn-ghost">登录</router-link>
            <router-link to="/register" class="btn btn-primary">注册</router-link>
          </template>
        </div>
      </div>
    </header>

    <!-- Hero -->
    <section class="hero">
      <div class="divider-line animate-in"></div>
      <div class="badge-tag animate-in animate-d1" style="margin-bottom:24px;">
        <span class="pulse-dot"></span> DeepSeek AI 驱动 · 免费使用
      </div>
      <h1 class="hero-title animate-in animate-d1">
        用 AI 管理<br><span class="gradient-text">你的代码</span>
      </h1>
      <p class="hero-desc animate-in animate-d2">
        存储代码片段，AI 自动解释、优化、生成测试。<br>像对话一样理解每一行代码。
      </p>
      <div class="hero-actions animate-in animate-d3">
        <router-link to="/register" class="btn btn-primary btn-lg">免费开始使用</router-link>
        <router-link to="/explore" class="btn btn-ghost btn-lg">探索代码库</router-link>
      </div>
      <div class="hero-stats animate-in animate-d4">
        <div class="stat-item">
          <span class="stat-number">34</span>
          <span class="stat-label">代码片段</span>
        </div>
        <div class="stat-item">
          <span class="stat-number primary">15</span>
          <span class="stat-label">编程语言</span>
        </div>
        <div class="stat-item">
          <span class="stat-number primary">AI</span>
          <span class="stat-label">智能分析</span>
        </div>
      </div>
    </section>

    <!-- AI 预览 -->
    <section class="ai-preview-section">
      <div class="ai-preview-card code-block">
        <div class="code-block-header">
          <span>&#x1F916; AI 分析</span>
          <div style="display:flex;gap:6px;">
            <span class="tab-tag active" style="padding:4px 12px;font-size:12px;">代码解释</span>
            <span class="tab-tag" style="padding:4px 12px;font-size:12px;">优化建议</span>
            <span class="tab-tag" style="padding:4px 12px;font-size:12px;">生成测试</span>
          </div>
        </div>
        <div class="code-block-body">
<span class="kw">public static void</span> <span class="fn">sort</span>(<span class="tp">int</span>[] arr, <span class="tp">int</span> left, <span class="tp">int</span> right) {
    <span class="kw">if</span> (left >= right) <span class="kw">return</span>;
    <span class="cm">// 三数取中</span>
    <span class="tp">int</span> mid = left + ((right - left) >> <span class="nm">1</span>);
    <span class="kw">if</span> (arr[left] > arr[mid]) <span class="fn">swap</span>(arr, left, mid);
}</div>
        <div class="ai-result-bubble">
          <div class="ai-avatar">&#x1F4A1;</div>
          <div class="ai-bubble-ai">
            <p><strong>三数取中法</strong>从首、中、尾三个元素中选取中间值作为基准，有效避免了最坏情况。时间复杂度 O(n log n)，空间 O(log n)。</p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useUserStore } from '@/store/user'

const userStore = useUserStore()
const isDark = ref(true)

function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.setAttribute('data-theme', isDark.value ? '' : 'light')
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

onMounted(() => {
  const saved = localStorage.getItem('theme')
  if (saved === 'light') {
    isDark.value = false
    document.documentElement.setAttribute('data-theme', 'light')
  }
})
</script>

<style scoped>
.home { min-height: 100vh; }

.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.logo { display: flex; align-items: center; gap: 8px; font-size: 18px; font-weight: 700; color: var(--text); }
.logo-icon { color: var(--primary); font-size: 20px; }
.nav-right { display: flex; align-items: center; gap: 14px; }
.nav-link { color: var(--text2); font-size: 14px; font-weight: 500; transition: color 0.15s; }
.nav-link:hover { color: var(--text); }
.theme-btn {
  background: var(--primary-light); border: none; border-radius: 50%;
  width: 34px; height: 34px; display: flex; align-items: center; justify-content: center;
  cursor: pointer; font-size: 16px;
}

.hero {
  text-align: center;
  padding: 120px 20px 60px;
  background: radial-gradient(ellipse at top, rgba(16,163,127,0.06) 0%, transparent 60%);
}
.hero-title {
  font-size: 56px;
  font-weight: 700;
  letter-spacing: -0.03em;
  line-height: 1.1;
  margin-bottom: 20px;
  color: var(--text);
}
.gradient-text {
  background: var(--gradient-text);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
.hero-desc {
  font-size: 17px;
  color: var(--text2);
  margin-bottom: 36px;
  line-height: 1.7;
  max-width: 560px;
  margin-left: auto;
  margin-right: auto;
}
.hero-actions { display: flex; gap: 12px; justify-content: center; margin-bottom: 56px; }
.btn-lg { padding: 14px 32px; font-size: 15px; border-radius: 8px; }
.hero-stats { display: flex; gap: 48px; justify-content: center; }
.stat-item { text-align: center; }

.ai-preview-section {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 20px 80px;
}
.ai-preview-card { border-radius: var(--radius-xl); }
.ai-result-bubble {
  display: flex;
  gap: 12px;
  padding: 0 16px 16px;
}
.ai-result-bubble p {
  font-size: 14px;
  color: var(--text2);
  line-height: 1.7;
}
.ai-result-bubble strong { color: var(--text); }

.nav-link {
  color: var(--text2);
}
</style>
