<template>
  <div class="admin-page">
    <header class="nav glass">
      <div class="nav-inner container">
        <router-link to="/" class="logo">
          <span class="logo-mark">&lt;/&gt;</span>
          <span class="logo-text">AiCodeHub</span>
        </router-link>
        <div class="nav-right">
          <router-link to="/dashboard" class="nav-link">控制台</router-link>
          <router-link to="/explore" class="nav-link">探索</router-link>
        </div>
      </div>
    </header>

    <div class="container" style="padding-top: 80px; padding-bottom: 40px">
      <h1 class="animate-in" style="font-size: 28px; font-weight: 700; margin-bottom: 32px; letter-spacing: -0.02em">
        管理后台
      </h1>

      <!-- 统计卡片 -->
      <div class="stats-row animate-in">
        <div class="stat-card card">
          <div class="stat-number">{{ stats.userCount }}</div>
          <div class="stat-label">注册用户</div>
        </div>
        <div class="stat-card card">
          <div class="stat-number">{{ stats.snippetCount }}</div>
          <div class="stat-label">代码片段</div>
        </div>
      </div>

      <!-- 标签页 -->
      <el-tabs v-model="activeTab" class="animate-in animate-in-delay-1">
        <el-tab-pane label="用户管理" name="users">
          <el-table :data="users" stripe style="width: 100%">
            <el-table-column prop="id" label="ID" width="60" />
            <el-table-column prop="username" label="用户名" width="140" />
            <el-table-column prop="email" label="邮箱" />
            <el-table-column label="角色" width="80">
              <template #default="{ row }">
                <el-tag :type="row.role === 1 ? 'danger' : 'info'" size="small">
                  {{ row.role === 1 ? '管理员' : '用户' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="状态" width="80">
              <template #default="{ row }">
                <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
                  {{ row.status === 1 ? '正常' : '禁用' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="注册时间" width="160">
              <template #default="{ row }">{{ formatDate(row.createdAt) }}</template>
            </el-table-column>
            <el-table-column label="操作" width="120">
              <template #default="{ row }">
                <el-button v-if="row.role !== 1" size="small"
                  :type="row.status === 1 ? 'warning' : 'success'"
                  @click="toggleUser(row)">
                  {{ row.status === 1 ? '禁用' : '启用' }}
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="代码片段" name="snippets">
          <el-table :data="snippets" stripe style="width: 100%">
            <el-table-column prop="id" label="ID" width="60" />
            <el-table-column prop="title" label="标题" />
            <el-table-column prop="language" label="语言" width="100" />
            <el-table-column label="浏览" width="70" prop="viewCount" />
            <el-table-column label="收藏" width="70" prop="likeCount" />
            <el-table-column label="公开" width="70">
              <template #default="{ row }">
                <el-tag :type="row.visibility === 1 ? 'success' : 'info'" size="small">
                  {{ row.visibility === 1 ? '公开' : '私有' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="120">
              <template #default="{ row }">
                <el-button size="small" type="danger" @click="removeSnippet(row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useUserStore } from '@/store/user'
import { getStats, getAllUsers, getAllSnippets, toggleUserStatus, deleteSnippet, deleteUser } from '@/api/admin'
import { ElMessage } from 'element-plus'

const userStore = useUserStore()
const activeTab = ref('users')
const stats = reactive({ userCount: 0, snippetCount: 0 })
const users = ref([])
const snippets = ref([])

function formatDate(d) {
  if (!d) return ''
  return new Date(d).toLocaleString('zh-CN')
}

async function loadStats() {
  try {
    const r = await getStats()
    Object.assign(stats, r.data)
  } catch {}
}

async function loadUsers() {
  try {
    const r = await getAllUsers()
    users.value = r.data || []
  } catch { ElMessage.error('加载用户失败') }
}

async function loadSnippets() {
  try {
    const r = await getAllSnippets()
    snippets.value = r.data || []
  } catch { ElMessage.error('加载片段失败') }
}

async function toggleUser(user) {
  const newStatus = user.status === 1 ? 0 : 1
  try {
    await toggleUserStatus(user.id, newStatus)
    user.status = newStatus
    ElMessage.success('操作成功')
  } catch {}
}

async function removeSnippet(row) {
  try {
    await deleteSnippet(row.id)
    snippets.value = snippets.value.filter(s => s.id !== row.id)
    stats.snippetCount--
    ElMessage.success('删除成功')
  } catch {}
}

onMounted(() => {
  loadStats()
  loadUsers()
  loadSnippets()
})
</script>

<style scoped>
.admin-page { min-height: 100vh; }
.nav { position: fixed; top: 0; left: 0; right: 0; z-index: 100; padding: 10px 0; }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.logo { display: flex; align-items: center; gap: 6px; font-weight: 700; font-size: 17px; color: var(--color-text); }
.logo-mark { color: var(--color-primary); }
.nav-right { display: flex; gap: 20px; }
.nav-link { color: var(--color-text-secondary); font-size: 14px; }
.nav-link:hover { color: var(--color-primary); }

.stats-row { display: flex; gap: 16px; margin-bottom: 24px; }
.stat-card { flex: 1; text-align: center; padding: 24px; }
.stat-number { font-size: 32px; font-weight: 700; color: var(--color-primary); }
.stat-label { font-size: 14px; color: var(--color-text-secondary); margin-top: 4px; }
</style>
