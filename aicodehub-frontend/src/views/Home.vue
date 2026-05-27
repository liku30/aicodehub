<template>
  <div class="home" style="position:relative;overflow:hidden;">
    <!-- 背景光晕 -->
    <div class="glow glow-green" style="top:-200px;left:-100px;"></div>
    <div class="glow glow-purple" style="top:200px;right:-200px;"></div>
    <div class="glow glow-blue" style="bottom:-100px;left:40%;"></div>

    <!-- 导航 -->
    <header class="nav">
      <div class="nav-inner container">
        <router-link to="/" class="logo">
          <span class="logo-icon">&lt;/&gt;</span>
          <span>AiCodeHub</span>
        </router-link>
        <div class="nav-right">
          <a href="#features" class="nav-link">功能</a>
          <a href="#demo" class="nav-link">演示</a>
          <button class="theme-btn" @click="toggleTheme">{{ isDark ? '&#x2600;&#xFE0F;' : '&#x1F319;' }}</button>
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

    <!-- ===== Hero ===== -->
    <section class="hero-section grid-bg">
      <div class="badge-tag animate-in">
        <span class="pulse-dot"></span> DeepSeek R1 驱动
        <span class="badge-new">NEW</span>
      </div>
      <h1 class="hero-title animate-in animate-d1" style="margin-top:28px;">
        用 AI 管理<br><span class="gradient-text">你的代码</span>
      </h1>
      <p class="hero-desc animate-in animate-d2">
        不止是代码存储 —— AI 自动解释、审查、优化、生成测试、<br>翻译代码、生成文档。像对话一样驾驭每一行代码。
      </p>
      <div class="hero-actions animate-in animate-d3">
        <router-link to="/register" class="btn btn-primary btn-lg">免费开始使用</router-link>
        <router-link to="/explore" class="btn btn-ghost btn-lg">浏览代码库</router-link>
      </div>
      <div class="hero-stats animate-in animate-d4">
        <div class="stat-item"><span class="stat-number">{{ snippetCount }}</span><span class="stat-label">代码片段</span></div>
        <div class="stat-item"><span class="stat-number primary">8</span><span class="stat-label">编程语言</span></div>
        <div class="stat-item"><span class="stat-number primary">6</span><span class="stat-label">AI 能力</span></div>
        <div class="stat-item"><span class="stat-number">100%</span><span class="stat-label">免费使用</span></div>
      </div>
    </section>

    <!-- ===== AI 实时演示 ===== -->
    <section class="section" id="demo">
      <div class="container">
        <h2 class="section-title animate-in">AI 实时分析演示</h2>
        <p class="section-subtitle animate-in animate-d1">粘贴代码，AI 自动理解上下文，给出专业级分析</p>
        <div class="ai-demo-card animate-in animate-d2">
          <div class="ai-demo-top">
            <div class="ai-dots"><span></span><span></span><span></span></div>
            <span style="margin-left:8px;">AiCodeHub AI · DeepSeek R1</span>
            <span style="margin-left:auto;color:var(--primary);">● 在线</span>
          </div>
          <div class="ai-demo-body">
            <div class="ai-code-side">
              <code><span class="kw">public static void</span> <span class="fn">quickSort</span>(<span class="tp">int</span>[] arr, <span class="tp">int</span> low, <span class="tp">int</span> high) {
    <span class="kw">if</span> (low &lt; high) {
        <span class="tp">int</span> pi = <span class="fn">partition</span>(arr, low, high);
        <span class="fn">quickSort</span>(arr, low, pi - <span class="nm">1</span>);
        <span class="fn">quickSort</span>(arr, pi + <span class="nm">1</span>, high);
    }
}

<span class="kw">private static int</span> <span class="fn">partition</span>(<span class="tp">int</span>[] arr, <span class="tp">int</span> low, <span class="tp">int</span> high) {
    <span class="tp">int</span> pivot = arr[high];
    <span class="tp">int</span> i = low - <span class="nm">1</span>;
    <span class="kw">for</span> (<span class="tp">int</span> j = low; j &lt; high; j++) {
        <span class="kw">if</span> (arr[j] &lt;= pivot) {
            i++; <span class="fn">swap</span>(arr, i, j);
        }
    }
    <span class="fn">swap</span>(arr, i + <span class="nm">1</span>, high);
    <span class="kw">return</span> i + <span class="nm">1</span>;
}</code>
            </div>
            <div class="ai-chat-side">
              <div class="chat-msg chat-user">分析这段快速排序的时间和空间复杂度</div>
              <div class="chat-msg chat-ai">
                <strong style="color:var(--text);">时间复杂度分析：</strong><br>
                平均情况 O(n log n)，最坏 O(n²)（已排序数组）。<br><br>
                <strong style="color:var(--text);">优化建议：</strong><br>
                可用「三数取中法」选择 pivot，避免最坏情况。
              </div>
              <div class="chat-msg chat-user">生成单元测试</div>
              <div class="chat-msg chat-ai">
                <strong style="color:var(--text);">已生成 3 个测试用例：</strong><br>
                ✅ 正常数组排序<br>
                ✅ 空数组 / 单元素<br>
                ✅ 含重复元素
              </div>
            </div>
          </div>
          <div class="ai-demo-input">
            <input type="text" placeholder="输入问题，如：解释这段代码、优化建议、生成测试..." readonly>
            <button class="btn btn-primary">发送</button>
          </div>
        </div>
      </div>
    </section>

    <!-- ===== AI 六大能力 ===== -->
    <section class="section dark-section" id="features">
      <div class="container">
        <h2 class="section-title animate-in">六大 AI 能力</h2>
        <p class="section-subtitle animate-in animate-d1">不止是存储，更是你的 AI 编程伙伴</p>
        <div class="ai-features-grid">
          <div class="ai-feat-card animate-in animate-d1">
            <div class="ai-feat-icon">&#x1F4A1;</div>
            <h3>代码解释</h3>
            <p>AI 逐行解读代码逻辑，用自然语言解释算法思路</p>
          </div>
          <div class="ai-feat-card animate-in animate-d2">
            <div class="ai-feat-icon">&#x26A1;</div>
            <h3>优化建议</h3>
            <p>自动分析时间/空间复杂度，给出性能优化方案</p>
          </div>
          <div class="ai-feat-card animate-in animate-d3">
            <div class="ai-feat-icon">&#x1F9EA;</div>
            <h3>生成测试</h3>
            <p>根据代码逻辑自动生成单元测试，覆盖各种场景</p>
          </div>
          <div class="ai-feat-card animate-in animate-d4">
            <div class="ai-feat-icon">&#x1F504;</div>
            <h3>代码翻译</h3>
            <p>一键将代码在 Java、Python、Go、JS 等语言间转换</p>
          </div>
          <div class="ai-feat-card animate-in animate-d5">
            <div class="ai-feat-icon">&#x1F4DD;</div>
            <h3>文档生成</h3>
            <p>自动生成 Javadoc/docstring，让代码可读性提升</p>
          </div>
          <div class="ai-feat-card animate-in animate-d6">
            <div class="ai-feat-icon">&#x1F50D;</div>
            <h3>代码审查</h3>
            <p>发现潜在 Bug、安全漏洞和代码异味，给出修复建议</p>
          </div>
        </div>
      </div>
    </section>

    <!-- ===== 四步工作流 ===== -->
    <section class="section">
      <div class="container">
        <h2 class="section-title animate-in">四步开始</h2>
        <p class="section-subtitle animate-in animate-d1">零学习成本，30 秒注册即可使用</p>
        <div class="steps-grid">
          <div class="step-card animate-in animate-d1">
            <div class="step-num s1">1</div>
            <h3>注册账号</h3>
            <p>邮箱快速注册<br>免费使用全部功能</p>
          </div>
          <div class="step-card animate-in animate-d2">
            <div class="step-num s2">2</div>
            <h3>粘贴代码</h3>
            <p>自动识别语言<br>标签分类管理</p>
          </div>
          <div class="step-card animate-in animate-d3">
            <div class="step-num s3">3</div>
            <h3>AI 分析</h3>
            <p>一键获取解释<br>优化和测试</p>
          </div>
          <div class="step-card animate-in animate-d4">
            <div class="step-num s4">4</div>
            <h3>社区分享</h3>
            <p>公开代码片段<br>发现优秀实践</p>
          </div>
        </div>
      </div>
    </section>

    <!-- ===== 为开发者打造（大卡片） ===== -->
    <section class="section dark-section">
      <div class="container">
        <h2 class="section-title animate-in">为开发者打造</h2>
        <p class="section-subtitle animate-in animate-d1">不只是代码管理，更是智能开发工作台</p>
        <div class="feat-big-grid">
          <div class="feat-big-card animate-in animate-d1">
            <h3>&#x1F916; AI 智能分析引擎</h3>
            <p>集成 DeepSeek R1 大模型，深度理解代码语义。不只是简单的关键词匹配，而是真正理解你的代码逻辑。</p>
            <div class="feat-tags">
              <span class="feat-tag">代码解释</span>
              <span class="feat-tag">优化建议</span>
              <span class="feat-tag">生成测试</span>
              <span class="feat-tag">复杂度分析</span>
            </div>
            <div class="feat-mini-code">
              <span class="cm">// AI 自动分析结果</span><br>
              复杂度: O(n log n) / O(log n)<br>
              建议: 使用三数取中法选择 pivot<br>
              测试: 已生成 3 个用例 ✅
            </div>
          </div>
          <div class="feat-big-card animate-in animate-d2">
            <h3>&#x26A1; 高效代码管理</h3>
            <p>多语言语法高亮、标签分类、全文搜索、收藏夹。用管理笔记的方式管理代码片段。</p>
            <div class="feat-tags">
              <span class="feat-tag">语法高亮</span>
              <span class="feat-tag">标签分类</span>
              <span class="feat-tag">全文搜索</span>
              <span class="feat-tag">收藏夹</span>
            </div>
            <div class="feat-mini-code">
              <span class="cm">// 搜索示例</span><br>
              搜索: "快速排序 Java" → 3 条结果<br>
              标签: #算法 #排序 #Java
            </div>
          </div>
          <div class="feat-big-card animate-in animate-d3">
            <h3>&#x1F504; 代码翻译器</h3>
            <p>一键将代码在不同编程语言间智能转换。保留逻辑结构，适配目标语言的惯用写法。</p>
            <div class="feat-tags">
              <span class="feat-tag">Java → Python</span>
              <span class="feat-tag">Python → Go</span>
              <span class="feat-tag">JS → TS</span>
            </div>
            <div class="feat-mini-code">
              <span class="cm">// 自动翻译</span><br>
              Java 快速排序 → Python 版本<br>
              已生成，包含类型注解 ✅
            </div>
          </div>
          <div class="feat-big-card animate-in animate-d4">
            <h3>&#x1F465; 开发者社区</h3>
            <p>公开你的代码片段，发现优秀实践。收藏、评论、与开发者社区共同成长。</p>
            <div class="feat-tags">
              <span class="feat-tag">公开分享</span>
              <span class="feat-tag">收藏评论</span>
              <span class="feat-tag">排行榜</span>
            </div>
            <div class="feat-mini-code">
              <span class="cm">// 社区动态</span><br>
              @dev 发布了 "JWT 验证中间件"<br>
              已有 28 人收藏 · 12 条评论
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- ===== 精选代码 ===== -->
    <section class="section">
      <div class="container">
        <h2 class="section-title animate-in">精选代码片段</h2>
        <p class="section-subtitle animate-in animate-d1">来自社区的高质量代码，AI 已经帮你分析好了</p>
        <div class="preview-grid">
          <div v-for="(s, i) in featuredSnippets" :key="i" class="card card-interactive animate-in" :style="{ animationDelay: (i * 0.1 + 0.1) + 's' }">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
              <span class="lang-pill" :style="{ background: s.color }">{{ s.lang }}</span>
              <span style="font-size:12px;color:var(--text3);">{{ s.title }}</span>
            </div>
            <div class="code-preview"><code>{{ s.code }}</code></div>
            <div class="prev-ai-tag">&#x1F4A1; {{ s.aiHint }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- ===== 数据统计 ===== -->
    <div class="stats-bar dark-section">
      <div class="container" style="display:contents;">
        <div class="stats-bar-item animate-in animate-d1">
          <span class="stats-bar-num g1">{{ snippetCount }}+</span>
          <span class="stats-bar-lbl">代码片段</span>
        </div>
        <div class="stats-bar-item animate-in animate-d2">
          <span class="stats-bar-num g2">8</span>
          <span class="stats-bar-lbl">编程语言</span>
        </div>
        <div class="stats-bar-item animate-in animate-d3">
          <span class="stats-bar-num g1">6</span>
          <span class="stats-bar-lbl">AI 能力</span>
        </div>
        <div class="stats-bar-item animate-in animate-d4">
          <span class="stats-bar-num g2">∞</span>
          <span class="stats-bar-lbl">免费使用</span>
        </div>
      </div>
    </div>

    <!-- ===== 支持语言 ===== -->
    <section class="section">
      <div class="container">
        <h2 class="section-title animate-in">支持的语言</h2>
        <p class="section-subtitle animate-in animate-d1">覆盖主流编程语言，持续扩展中</p>
        <div class="lang-grid animate-in animate-d2">
          <div v-for="lang in supportedLangs" :key="lang.name" class="lang-card">
            <span class="lang-icon" :style="{ background: lang.color }">{{ lang.icon }}</span>
            <div>
              <span class="lang-name">{{ lang.name }}</span>
              <span class="lang-count">{{ lang.count }} 片段</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- ===== 用户评价 ===== -->
    <section class="section dark-section">
      <div class="container">
        <h2 class="section-title animate-in">用户怎么说</h2>
        <p class="section-subtitle animate-in animate-d1">来自真实开发者的使用体验</p>
        <div class="testimonials-grid">
          <div class="test-card animate-in animate-d1">
            <div class="test-stars">★★★★★</div>
            <p class="test-text">"AI 解释代码真的太方便了，以前看别人代码要半小时，现在 AI 秒级解读，还能给出优化建议。"</p>
            <div class="test-author">
              <div class="test-avatar" style="background:var(--gradient);">W</div>
              <div>
                <div class="test-name">王同学</div>
                <div class="test-role">计算机科学 · 大三</div>
              </div>
            </div>
          </div>
          <div class="test-card animate-in animate-d2">
            <div class="test-stars">★★★★★</div>
            <p class="test-text">"生成测试用例功能太赞了！以前写测试最头疼，现在 AI 自动帮我生成，覆盖率还很高。"</p>
            <div class="test-author">
              <div class="test-avatar" style="background:linear-gradient(135deg,#6c9eff,#a970ff);">L</div>
              <div>
                <div class="test-name">李同学</div>
                <div class="test-role">软件工程 · 研一</div>
              </div>
            </div>
          </div>
          <div class="test-card animate-in animate-d3">
            <div class="test-stars">★★★★★</div>
            <p class="test-text">"代码翻译功能帮我把 Java 作业转成了 Python，逻辑完全一致，还能适配 Python 的惯用写法。"</p>
            <div class="test-author">
              <div class="test-avatar" style="background:linear-gradient(135deg,#f0883e,#10a37f);">Z</div>
              <div>
                <div class="test-name">赵同学</div>
                <div class="test-role">数据科学 · 大四</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- ===== FAQ ===== -->
    <section class="section">
      <div class="container">
        <h2 class="section-title animate-in">常见问题</h2>
        <div class="faq-list">
          <div v-for="(faq, i) in faqs" :key="i" class="faq-item animate-in" :class="{ open: faq.open }" :style="{ animationDelay: (i * 0.1 + 0.1) + 's' }">
            <div class="faq-q" @click="faq.open = !faq.open">
              {{ faq.q }}
              <span class="faq-arrow">{{ faq.open ? '−' : '+' }}</span>
            </div>
            <div class="faq-a" v-show="faq.open">{{ faq.a }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- ===== CTA ===== -->
    <section class="cta-section">
      <h2 class="animate-in">准备好开始了吗？</h2>
      <p class="animate-in animate-d1">免费注册，立即体验 <span class="gradient-text">AI 代码管理</span></p>
      <div class="cta-actions animate-in animate-d2">
        <router-link to="/register" class="btn btn-primary btn-lg">免费注册</router-link>
        <router-link to="/explore" class="btn btn-ghost btn-lg">浏览代码库</router-link>
      </div>
      <p class="cta-hint animate-in animate-d3">无需信用卡 · 即刻使用全部功能</p>
    </section>

    <!-- ===== 页脚 ===== -->
    <footer class="footer-section">
      <div class="container">
        <div class="footer-grid">
          <div>
            <div class="logo" style="margin-bottom:14px;"><span class="logo-icon">&lt;/&gt;</span><span>AiCodeHub</span></div>
            <p style="color:var(--text3);font-size:14px;max-width:280px;line-height:1.7;">AI 驱动的代码片段管理平台。存储、分析、分享代码，让每一行代码都有 AI 加持。</p>
          </div>
          <div>
            <h4 style="color:var(--text);font-size:14px;font-weight:700;margin-bottom:14px;">产品</h4>
            <div style="display:flex;flex-direction:column;gap:10px;">
              <router-link to="/explore" style="color:var(--text2);font-size:14px;">探索代码库</router-link>
              <router-link to="/register" style="color:var(--text2);font-size:14px;">免费注册</router-link>
              <span style="color:var(--text2);font-size:14px;">AI 分析</span>
              <span style="color:var(--text2);font-size:14px;">代码翻译</span>
            </div>
          </div>
          <div>
            <h4 style="color:var(--text);font-size:14px;font-weight:700;margin-bottom:14px;">技术栈</h4>
            <div style="display:flex;flex-direction:column;gap:10px;font-size:14px;color:var(--text2);">
              <span>Spring Boot 3</span>
              <span>Vue 3 + Vite</span>
              <span>MySQL 8 + Redis</span>
              <span>DeepSeek R1</span>
            </div>
          </div>
          <div>
            <h4 style="color:var(--text);font-size:14px;font-weight:700;margin-bottom:14px;">支持语言</h4>
            <div style="display:flex;flex-direction:column;gap:10px;font-size:14px;color:var(--text2);">
              <span>Java · Python</span>
              <span>JavaScript · TS</span>
              <span>Go · C++</span>
              <span>SQL · Shell</span>
            </div>
          </div>
        </div>
        <div class="footer-bottom">
          <span>&copy; 2026 AiCodeHub. 用 AI 让代码管理更智能。</span>
          <span>Spring Boot 3 · Vue 3 · MySQL · DeepSeek AI</span>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useUserStore } from '@/store/user'

const userStore = useUserStore()
const isDark = ref(true)
const snippetCount = ref(0)

const featuredSnippets = [
  { lang: 'Java', color: '#ED8B00', title: '快速排序', aiHint: 'O(n log n) · 三数取中优化 · 已生成3个测试', code: 'public static void sort(int[] arr, int l, int r) {\n    if (l >= r) return;\n    int mid = l + ((r - l) >> 1);\n    if (arr[l] > arr[mid]) swap(arr, l, mid);\n}' },
  { lang: 'Python', color: '#3776AB', title: '装饰器模式', aiHint: '设计模式 · 可增加指数退避策略', code: 'def retry(max_attempts=3):\n    def decorator(func):\n        @functools.wraps(func)\n        def wrapper(*a, **kw):\n            for i in range(max_attempts):\n                try: return func(*a, **kw)' },
  { lang: 'JavaScript', color: '#F7DF1E', title: '防抖函数', aiHint: '性能优化 · 建议添加 leading 立即执行选项', code: 'function debounce(fn, delay = 300) {\n    let timer = null;\n    return function(...args) {\n        clearTimeout(timer);\n        timer = setTimeout(() => {\n            fn.apply(this, args);\n        }, delay);\n    };\n}' },
]

const supportedLangs = [
  { name: 'Java', icon: 'J', color: '#ED8B00', count: 12 },
  { name: 'Python', icon: 'Py', color: '#3776AB', count: 8 },
  { name: 'JavaScript', icon: 'JS', color: '#F7DF1E', count: 5 },
  { name: 'TypeScript', icon: 'TS', color: '#3178C6', count: 3 },
  { name: 'Go', icon: 'Go', color: '#00ADD8', count: 2 },
  { name: 'C++', icon: 'C+', color: '#00599C', count: 2 },
  { name: 'SQL', icon: 'SQ', color: '#336791', count: 1 },
  { name: 'Shell', icon: 'Sh', color: '#89e051', count: 1 },
]

const faqs = reactive([
  { q: 'AiCodeHub 是免费的吗？', a: '是的！AiCodeHub 目前完全免费使用，包括所有 AI 功能。代码片段存储、AI 分析、社区分享全部免费开放。', open: true },
  { q: 'AI 使用的是什么模型？', a: '我们集成 DeepSeek R1 大语言模型，专注于代码理解和生成。它能深度理解代码语义，提供专业级的分析和建议。', open: false },
  { q: '支持哪些编程语言？', a: '目前支持 Java、Python、JavaScript、TypeScript、Go、C/C++、Rust、SQL、Shell 等主流语言，未来会持续扩展。', open: false },
  { q: '代码片段可以设为私有吗？', a: '当然可以！创建代码片段时可以选择「公开」或「私有」，私有片段只有你自己能看到。', open: false },
  { q: '如何保证代码安全？', a: '所有数据通过 HTTPS 加密传输，密码使用 BCrypt 加密存储。JWT Token 认证确保只有你能访问自己的数据。', open: false },
])

function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.setAttribute('data-theme', isDark.value ? '' : 'light')
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

onMounted(() => {
  const saved = localStorage.getItem('theme')
  if (saved === 'light') { isDark.value = false; document.documentElement.setAttribute('data-theme', 'light') }
})
</script>

<style scoped>
.home { min-height: 100vh; }

/* 导航 */
.nav { position: sticky; top: 0; z-index: 100; }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.logo { display: flex; align-items: center; gap: 8px; font-size: 18px; font-weight: 700; color: var(--text); }
.logo-icon { color: var(--primary); font-size: 20px; }
.nav-right { display: flex; align-items: center; gap: 16px; }
.nav-link { color: var(--text2); font-size: 14px; transition: color 0.15s; }
.nav-link:hover { color: var(--text); }
.theme-btn { background: var(--primary-light); border: none; border-radius: 50%; width: 34px; height: 34px; display: flex; align-items: center; justify-content: center; cursor: pointer; font-size: 16px; }
.btn-lg { padding: 14px 32px; font-size: 15px; border-radius: 10px; }
.btn-pill { border-radius: 9999px; }

/* Hero */
.hero-section { text-align: center; padding: 130px 20px 80px; background: radial-gradient(ellipse at top, rgba(16,163,127,0.07) 0%, transparent 50%), radial-gradient(ellipse at 30% 80%, rgba(169,112,255,0.04) 0%, transparent 40%); }
.badge-tag { display: inline-flex; align-items: center; gap: 8px; padding: 6px 16px; border-radius: 20px; border: 1px solid var(--border); background: var(--surface2); font-size: 13px; color: var(--text2); }
.badge-new { background: var(--primary-light); color: var(--primary); font-size: 11px; font-weight: 700; padding: 2px 8px; border-radius: 4px; }
.pulse-dot { width: 6px; height: 6px; border-radius: 50%; background: var(--primary); display: inline-block; animation: pulse 2s infinite; }
@keyframes pulse { 0%, 100% { opacity: 0.6; } 50% { opacity: 1; } }
.hero-title { font-size: 60px; font-weight: 800; letter-spacing: -0.04em; line-height: 1.1; margin-bottom: 20px; color: var(--text); }
.gradient-text { background: var(--gradient-text); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.hero-desc { font-size: 18px; color: var(--text2); margin-bottom: 40px; line-height: 1.7; max-width: 580px; margin-left: auto; margin-right: auto; }
.hero-actions { display: flex; gap: 14px; justify-content: center; margin-bottom: 60px; }
.hero-stats { display: flex; gap: 56px; justify-content: center; }
.stat-item { text-align: center; }
.stat-number { font-size: 36px; font-weight: 800; color: var(--text); display: block; font-variant-numeric: tabular-nums; }
.stat-number.primary { color: var(--primary); }
.stat-label { font-size: 13px; color: var(--text3); margin-top: 4px; }

/* Section */
.section { padding: 80px 0; }
.dark-section { background: var(--surface); border-top: 1px solid var(--border); border-bottom: 1px solid var(--border); }
.section-title { text-align: center; font-size: 32px; font-weight: 800; letter-spacing: -0.03em; margin-bottom: 12px; color: var(--text); }
.section-subtitle { text-align: center; font-size: 16px; color: var(--text2); margin-bottom: 48px; max-width: 560px; margin-left: auto; margin-right: auto; line-height: 1.7; }

/* AI Demo */
.ai-demo-card { max-width: 900px; margin: 0 auto; border-radius: 16px; overflow: hidden; background: var(--surface); border: 1px solid var(--border); box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
.ai-demo-top { display: flex; align-items: center; gap: 8px; padding: 12px 18px; background: var(--surface); border-bottom: 1px solid var(--border); font-size: 13px; color: var(--text3); }
.ai-dots { display: flex; gap: 6px; }
.ai-dots span { width: 10px; height: 10px; border-radius: 50%; }
.ai-dots span:nth-child(1) { background: #ff5f57; }
.ai-dots span:nth-child(2) { background: #ffbd2e; }
.ai-dots span:nth-child(3) { background: #28c840; }
.ai-demo-body { display: grid; grid-template-columns: 1fr 1fr; min-height: 300px; }
.ai-code-side { padding: 16px; font-family: 'Fira Code', 'Cascadia Code', monospace; font-size: 13px; line-height: 1.7; color: #abb2bf; border-right: 1px solid var(--border); overflow: hidden; }
.ai-chat-side { padding: 16px; display: flex; flex-direction: column; gap: 10px; overflow: hidden; }
.chat-msg { padding: 10px 14px; border-radius: 12px; font-size: 13px; line-height: 1.6; }
.chat-user { background: var(--primary-light); color: var(--primary); align-self: flex-end; border-bottom-right-radius: 4px; max-width: 85%; }
.chat-ai { background: var(--surface2); border: 1px solid var(--border); color: var(--text2); align-self: flex-start; border-bottom-left-radius: 4px; max-width: 90%; }
.ai-demo-input { display: flex; gap: 8px; padding: 12px 16px; border-top: 1px solid var(--border); }
.ai-demo-input input { flex: 1; background: var(--surface2); border: 1px solid var(--border); border-radius: 8px; padding: 10px 14px; color: var(--text); font-size: 13px; outline: none; }
.ai-demo-input input::placeholder { color: var(--text3); }
.kw { color: #c678dd; } .tp { color: #e5c07b; } .fn { color: #61afef; } .nm { color: #d19a66; } .cm { color: #5c6370; font-style: italic; }

/* AI Features */
.ai-features-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; }
.ai-feat-card { background: var(--bg); border: 1px solid var(--border); border-radius: 16px; padding: 28px 20px; text-align: center; transition: all 0.25s; }
.ai-feat-card:hover { border-color: var(--primary); transform: translateY(-6px); box-shadow: 0 8px 30px rgba(16,163,127,0.1); }
.ai-feat-icon { width: 52px; height: 52px; border-radius: 14px; background: var(--primary-light); display: flex; align-items: center; justify-content: center; margin: 0 auto 14px; font-size: 26px; }
.ai-feat-card h3 { font-size: 15px; font-weight: 700; margin-bottom: 6px; color: var(--text); }
.ai-feat-card p { font-size: 13px; color: var(--text2); line-height: 1.6; }

/* Steps */
.steps-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; max-width: 1000px; margin: 0 auto; }
.step-card { text-align: center; }
.step-num { width: 56px; height: 56px; border-radius: 50%; display: flex; align-items: center; justify-content:center; margin: 0 auto 14px; font-size: 22px; font-weight: 800; color: #fff; }
.s1 { background: var(--gradient); }
.s2 { background: linear-gradient(135deg, #19c37d, #6c9eff); }
.s3 { background: linear-gradient(135deg, #6c9eff, #a970ff); }
.s4 { background: linear-gradient(135deg, #a970ff, #f0883e); }
.step-card h3 { font-size: 15px; font-weight: 700; margin-bottom: 6px; color: var(--text); }
.step-card p { font-size: 13px; color: var(--text2); line-height: 1.5; }

/* Feature Big Cards */
.feat-big-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
.feat-big-card { background: var(--bg); border: 1px solid var(--border); border-radius: 16px; padding: 32px; transition: all 0.25s; }
.feat-big-card:hover { border-color: var(--border2); transform: translateY(-4px); box-shadow: 0 10px 30px rgba(0,0,0,0.15); }
.feat-big-card h3 { font-size: 18px; font-weight: 700; margin-bottom: 10px; color: var(--text); }
.feat-big-card > p { font-size: 14px; color: var(--text2); line-height: 1.7; margin-bottom: 14px; }
.feat-tags { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 14px; }
.feat-tag { display: inline-block; padding: 4px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; background: var(--primary-light); color: var(--primary); }
.feat-mini-code { background: #1a1a1a; border: 1px solid #2a2a2a; border-radius: 10px; padding: 14px; font-family: 'Fira Code', monospace; font-size: 12px; line-height: 1.6; color: #abb2bf; }

/* Featured Snippets */
.preview-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; }
.lang-pill { display: inline-block; padding: 3px 10px; border-radius: 9999px; font-size: 12px; font-weight: 700; color: #fff; }
.code-preview { background: #1a1a1a; border: 1px solid #2a2a2a; border-radius: 8px; padding: 14px; font-family: 'Fira Code', monospace; font-size: 12px; line-height: 1.5; overflow: hidden; max-height: 100px; -webkit-mask-image: linear-gradient(black 60%, transparent); mask-image: linear-gradient(black 60%, transparent); color: #abb2bf; margin-bottom: 10px; }
.prev-ai-tag { display: flex; align-items: center; gap: 6px; padding: 8px 12px; background: var(--primary-light); border-radius: 8px; font-size: 12px; color: var(--primary); }

/* Stats Bar */
.stats-bar { padding: 48px 0; display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
.stats-bar-item { text-align: center; }
.stats-bar-num { font-size: 40px; font-weight: 800; display: block; margin-bottom: 4px; }
.stats-bar-num.g1 { background: var(--gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.stats-bar-num.g2 { background: var(--gradient-text); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.stats-bar-lbl { font-size: 14px; color: var(--text3); }

/* 支持语言 */
.lang-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; max-width: 640px; margin: 0 auto; }
.lang-card { display: flex; align-items: center; gap: 10px; padding: 14px 18px; background: var(--surface); border: 1px solid var(--border); border-radius: 12px; transition: all 0.25s; }
.lang-card:hover { border-color: var(--border2); transform: translateY(-3px); }
.lang-icon { width: 36px; height: 36px; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 13px; font-weight: 800; }
.lang-name { font-size: 14px; color: var(--text); font-weight: 600; display: block; }
.lang-count { font-size: 11px; color: var(--text3); }

/* 用户评价 */
.testimonials-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; }
.test-card { background: var(--bg); border: 1px solid var(--border); border-radius: 14px; padding: 24px; transition: all 0.2s; }
.test-card:hover { border-color: var(--border2); transform: translateY(-2px); }
.test-stars { color: #f0883e; font-size: 14px; margin-bottom: 10px; }
.test-text { font-size: 14px; color: var(--text2); line-height: 1.7; margin-bottom: 16px; font-style: italic; }
.test-author { display: flex; align-items: center; gap: 10px; }
.test-avatar { width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 700; color: #fff; }
.test-name { font-size: 14px; font-weight: 600; color: var(--text); }
.test-role { font-size: 12px; color: var(--text3); }

/* FAQ */
.faq-list { max-width: 700px; margin: 0 auto; display: flex; flex-direction: column; gap: 8px; }
.faq-item { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; overflow: hidden; transition: border-color 0.2s; }
.faq-item:hover { border-color: var(--border2); }
.faq-q { padding: 18px 22px; font-size: 15px; font-weight: 600; cursor: pointer; display: flex; justify-content: space-between; align-items: center; color: var(--text); }
.faq-arrow { font-size: 20px; color: var(--text3); transition: transform 0.2s; }
.faq-a { padding: 0 22px 18px; font-size: 14px; color: var(--text2); line-height: 1.7; }

/* CTA */
.cta-section { text-align: center; padding: 100px 20px; background: radial-gradient(ellipse at center, rgba(16,163,127,0.1) 0%, transparent 60%), radial-gradient(ellipse at 70% 30%, rgba(169,112,255,0.06) 0%, transparent 40%); }
.cta-section h2 { font-size: 42px; font-weight: 800; letter-spacing: -0.03em; margin-bottom: 16px; color: var(--text); }
.cta-section > p { font-size: 18px; color: var(--text2); margin-bottom: 36px; }
.cta-actions { display: flex; gap: 14px; justify-content: center; }
.cta-hint { font-size: 13px; color: var(--text3); margin-top: 16px; }

/* 页脚 */
.footer-section { padding: 56px 0 32px; border-top: 1px solid var(--border); }
.footer-grid { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 40px; }
.footer-bottom { border-top: 1px solid var(--border); margin-top: 36px; padding-top: 24px; display: flex; justify-content: space-between; align-items: center; font-size: 13px; color: var(--text3); }

@media (max-width: 768px) {
  .hero-title { font-size: 36px; }
  .ai-features-grid { grid-template-columns: repeat(2, 1fr); }
  .feat-big-grid { grid-template-columns: 1fr; }
  .preview-grid { grid-template-columns: 1fr; }
  .steps-grid { grid-template-columns: repeat(2, 1fr); }
  .testimonials-grid { grid-template-columns: 1fr; }
  .lang-grid { grid-template-columns: repeat(2, 1fr); }
  .footer-grid { grid-template-columns: 1fr 1fr; }
  .ai-demo-body { grid-template-columns: 1fr; }
  .hero-stats { gap: 24px; flex-wrap: wrap; }
}
</style>
