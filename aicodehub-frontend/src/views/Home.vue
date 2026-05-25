<template>
  <div class="home">
    <!-- 导航栏 -->
    <header class="nav glass" :class="{ scrolled: isScrolled }">
      <div class="nav-inner container">
        <router-link to="/" class="logo">
          <span class="logo-mark">&lt;/&gt;</span>
          <span class="logo-text">AiCodeHub</span>
        </router-link>
        <div class="nav-right">
          <router-link to="/explore" class="nav-link">探索</router-link>
          <button class="theme-toggle" @click="toggleTheme" :title="isDark ? '切换亮色' : '切换暗色'">
            {{ isDark ? '&#x2600;&#xFE0F;' : '&#x1F319;' }}
          </button>
          <template v-if="userStore.isLoggedIn()">
            <router-link to="/dashboard" class="btn btn-ghost" style="padding: 6px 16px; font-size: 13px">控制台</router-link>
          </template>
          <template v-else>
            <router-link to="/login" class="btn btn-ghost" style="padding: 6px 16px; font-size: 13px">登录</router-link>
            <router-link to="/register" class="btn btn-primary" style="padding: 6px 16px; font-size: 13px">注册</router-link>
          </template>
        </div>
      </div>
    </header>

    <!-- Hero 区域 -->
    <section class="hero">
      <div class="hero-content animate-in">
        <div class="hero-badge">AI 驱动的代码管理平台</div>
        <h1 class="hero-title">
          让代码管理<br>更<em>智能</em>
        </h1>
        <p class="hero-desc">
          存储、组织、分析你的代码片段。集成 DeepSeek 大模型，<br>
          提供代码解释、优化建议和测试用例生成。
        </p>
        <div class="hero-actions">
          <router-link to="/register" class="btn btn-primary btn-lg">免费开始使用</router-link>
          <router-link to="/explore" class="btn btn-ghost btn-lg">浏览代码库</router-link>
        </div>
        <div class="hero-stats">
          <div class="stat">
            <span class="stat-value">30+</span>
            <span class="stat-label">代码片段</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat">
            <span class="stat-value">8</span>
            <span class="stat-label">编程语言</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat">
            <span class="stat-value">AI</span>
            <span class="stat-label">智能分析</span>
          </div>
        </div>
      </div>
    </section>

    <!-- 特性区域 -->
    <section class="features">
      <div class="container">
        <h2 class="section-title animate-in">为开发者打造</h2>
        <div class="features-grid">
          <div class="feature-card animate-in animate-in-delay-1">
            <div class="feature-icon-wrap">
              <span class="feature-icon">&#x1F916;</span>
            </div>
            <h3>AI 智能分析</h3>
            <p>基于 DeepSeek 大模型，逐行解释代码逻辑，识别潜在问题，生成单元测试用例。</p>
          </div>
          <div class="feature-card animate-in animate-in-delay-2">
            <div class="feature-icon-wrap">
              <span class="feature-icon">&#x26A1;</span>
            </div>
            <h3>高效管理</h3>
            <p>支持多语言语法高亮、标签分类、全文搜索。用管理笔记的方式管理代码。</p>
          </div>
          <div class="feature-card animate-in animate-in-delay-3">
            <div class="feature-icon-wrap">
              <span class="feature-icon">&#x1F465;</span>
            </div>
            <h3>社区共享</h3>
            <p>公开优秀的代码片段，发现最佳实践。收藏、评论、与开发者社区共同成长。</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 代码预览区域 -->
    <section class="preview-section">
      <div class="container-narrow">
        <h2 class="section-title animate-in">精选代码片段</h2>
        <div class="preview-grid">
          <div class="preview-card card card-interactive animate-in animate-in-delay-1" @click="$router.push('/explore')">
            <div class="preview-header">
              <span class="lang-tag" style="background: #ED8B00">Java</span>
              <span class="preview-meta">LRU 缓存</span>
            </div>
            <pre class="code-preview">public class LRUCache&lt;K, V&gt; extends LinkedHashMap&lt;K, V&gt; {
    private final int capacity;
    public LRUCache(int capacity) {
        super(capacity, 0.75f, true);
        this.capacity = capacity;
    }
}</pre>
          </div>
          <div class="preview-card card card-interactive animate-in animate-in-delay-2" @click="$router.push('/explore')">
            <div class="preview-header">
              <span class="lang-tag" style="background: #3776AB">Python</span>
              <span class="preview-meta">装饰器模式</span>
            </div>
            <pre class="code-preview">def retry(max_attempts=3, delay=1.0):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(max_attempts):
                try: return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts - 1: raise
                    time.sleep(delay * attempt)
        return wrapper
    return decorator</pre>
          </div>
          <div class="preview-card card card-interactive animate-in animate-in-delay-3" @click="$router.push('/explore')">
            <div class="preview-header">
              <span class="lang-tag" style="background: #F7DF1E; color: #333">JavaScript</span>
              <span class="preview-meta">防抖与节流</span>
            </div>
            <pre class="code-preview">function debounce(fn, delay, immediate = false) {
    let timer = null;
    return function(...args) {
        if (timer) clearTimeout(timer);
        if (immediate && !timer) fn.apply(this, args);
        timer = setTimeout(() => {
            timer = null;
            if (!immediate) fn.apply(this, args);
        }, delay);
    };
}</pre>
          </div>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <footer class="footer">
      <div class="container">
        <p>&copy; 2026 AiCodeHub. 用 AI 让代码管理更智能。</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useUserStore } from '@/store/user'

const userStore = useUserStore()
const isScrolled = ref(false)
const isDark = ref(false)

function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.setAttribute('data-theme', isDark.value ? 'dark' : '')
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

function handleScroll() {
  isScrolled.value = window.scrollY > 10
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
  isDark.value = localStorage.getItem('theme') === 'dark'
  if (isDark.value) document.documentElement.setAttribute('data-theme', 'dark')
})
onUnmounted(() => window.removeEventListener('scroll', handleScroll))
</script>

<style scoped>
.home { min-height: 100vh; }

/* 导航 */
.nav {
  position: fixed; top: 0; left: 0; right: 0; z-index: 100;
  padding: 12px 0;
  transition: all var(--duration-normal) var(--ease-out);
}
.nav.scrolled { box-shadow: var(--shadow-md); }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.logo { display: flex; align-items: center; gap: 8px; font-weight: 700; font-size: 18px; color: var(--color-text); }
.logo-mark { color: var(--color-primary); font-size: 20px; }
.nav-right { display: flex; align-items: center; gap: 12px; }
.nav-link { color: var(--color-text-secondary); font-size: 14px; transition: color 0.2s; }
.nav-link:hover { color: var(--color-text); }
.theme-toggle { background: none; border: none; font-size: 18px; cursor: pointer; padding: 4px; line-height: 1; }

/* Hero */
.hero {
  padding: 160px 20px 100px;
  text-align: center;
  background: var(--gradient-hero);
}
.hero-content { max-width: 720px; margin: 0 auto; }
.hero-badge {
  display: inline-block;
  padding: 6px 16px;
  border-radius: var(--radius-full);
  background: var(--color-primary-light);
  color: var(--color-primary);
  font-size: 13px;
  font-weight: 600;
  margin-bottom: 24px;
  letter-spacing: 0.03em;
}
.hero-title {
  font-size: clamp(40px, 7vw, 64px);
  font-weight: 700;
  line-height: 1.1;
  letter-spacing: -0.03em;
  color: var(--color-text);
  margin-bottom: 20px;
}
.hero-title em {
  font-style: normal;
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
.hero-desc {
  font-size: 18px;
  color: var(--color-text-secondary);
  line-height: 1.7;
  margin-bottom: 36px;
}
.hero-actions { display: flex; gap: 12px; justify-content: center; margin-bottom: 48px; }
.btn-lg { padding: 14px 28px; font-size: 16px; }
.hero-stats { display: flex; align-items: center; justify-content: center; gap: 32px; }
.stat { text-align: center; }
.stat-value { display: block; font-size: 28px; font-weight: 700; color: var(--color-text); }
.stat-label { font-size: 13px; color: var(--color-text-tertiary); }
.stat-divider { width: 1px; height: 32px; background: var(--color-border-strong); }

/* 特性 */
.features { padding: 100px 0; }
.section-title {
  text-align: center;
  font-size: 32px;
  font-weight: 700;
  letter-spacing: -0.02em;
  margin-bottom: 48px;
  color: var(--color-text);
}
.features-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
.feature-card {
  text-align: center;
  padding: 40px 28px;
  background: var(--color-surface);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-card);
  transition: all var(--duration-normal) var(--ease-out);
}
.feature-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-lg); }
.feature-icon-wrap {
  width: 56px; height: 56px;
  border-radius: var(--radius-md);
  background: var(--color-primary-light);
  display: flex; align-items: center; justify-content: center;
  margin: 0 auto 20px;
}
.feature-icon { font-size: 28px; }
.feature-card h3 { font-size: 18px; font-weight: 600; margin-bottom: 10px; }
.feature-card p { font-size: 14px; color: var(--color-text-secondary); line-height: 1.7; }

/* 代码预览 */
.preview-section { padding: 60px 0 100px; }
.preview-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
.preview-card { padding: 20px; }
.preview-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
.preview-meta { font-size: 13px; color: var(--color-text-tertiary); }

/* 页脚 */
.footer { padding: 48px 0; text-align: center; color: var(--color-text-tertiary); font-size: 14px; }

@media (max-width: 768px) {
  .features-grid, .preview-grid { grid-template-columns: 1fr; }
  .hero-title { font-size: 36px; }
  .hero-desc { font-size: 16px; }
}
</style>
