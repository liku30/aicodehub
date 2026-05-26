<template>
  <div class="admin-page">
    <header class="nav">
      <div class="nav-inner container">
        <router-link to="/" class="logo">
          <span class="logo-icon">&lt;/&gt;</span><span>AiCodeHub</span>
        </router-link>
        <div class="nav-right">
          <router-link to="/dashboard" class="nav-link">控制台</router-link>
          <router-link to="/explore" class="nav-link">探索</router-link>
        </div>
      </div>
    </header>
    <div class="container" style="padding-top:80px;padding-bottom:40px;">
      <h1 class="animate-in" style="font-size:28px;font-weight:700;margin-bottom:32px;letter-spacing:-0.02em;">管理后台</h1>
      <div class="stats-row animate-in">
        <div class="stat-box card"><div class="stat-num">{{ stats.userCount }}</div><div class="stat-lbl">注册用户</div></div>
        <div class="stat-box card"><div class="stat-num">{{ stats.snippetCount }}</div><div class="stat-lbl">代码片段</div></div>
      </div>
      <el-tabs v-model="activeTab" class="animate-in animate-d1">
        <el-tab-pane label="用户管理" name="users">
          <el-table :data="users" stripe style="width:100%;">
            <el-table-column prop="id" label="ID" width="60" />
            <el-table-column prop="username" label="用户名" width="140" />
            <el-table-column prop="email" label="邮箱" />
            <el-table-column label="角色" width="80"><template #default="{ row }"><el-tag :type="row.role===1?'danger':'info'" size="small">{{ row.role===1?'管理员':'用户' }}</el-tag></template></el-table-column>
            <el-table-column label="状态" width="80"><template #default="{ row }"><el-tag :type="row.status===1?'success':'danger'" size="small">{{ row.status===1?'正常':'禁用' }}</el-tag></template></el-table-column>
            <el-table-column label="操作" width="120"><template #default="{ row }"><el-button v-if="row.role!==1" size="small" :type="row.status===1?'warning':'success'" @click="toggleUser(row)">{{ row.status===1?'禁用':'启用' }}</el-button></template></el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="代码片段" name="snippets">
          <el-table :data="snippets" stripe style="width:100%;">
            <el-table-column prop="id" label="ID" width="60" />
            <el-table-column prop="title" label="标题" />
            <el-table-column prop="language" label="语言" width="100" />
            <el-table-column label="浏览" width="70" prop="viewCount" />
            <el-table-column label="操作" width="120"><template #default="{ row }"><el-button size="small" type="danger" @click="removeSnippet(row)">删除</el-button></template></el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getStats, getAllUsers, getAllSnippets, toggleUserStatus, deleteSnippet } from '@/api/admin'
import { ElMessage } from 'element-plus'

const activeTab = ref('users')
const stats = reactive({ userCount: 0, snippetCount: 0 })
const users = ref([]), snippets = ref([])

async function loadAll() {
  try { const r = await getStats(); Object.assign(stats, r.data) } catch {}
  try { const r = await getAllUsers(); users.value = r.data || [] } catch {}
  try { const r = await getAllSnippets(); snippets.value = r.data || [] } catch {}
}
async function toggleUser(u) { const ns = u.status===1?0:1; try { await toggleUserStatus(u.id, ns); u.status = ns; ElMessage.success('操作成功') } catch {} }
async function removeSnippet(s) { try { await deleteSnippet(s.id); snippets.value = snippets.value.filter(x=>x.id!==s.id); stats.snippetCount--; ElMessage.success('删除成功') } catch {} }
onMounted(loadAll)
</script>

<style scoped>
.admin-page { min-height: 100vh; }
.nav { position: fixed; top: 0; left: 0; right: 0; z-index: 100; padding: 10px 0; background: rgba(17,17,17,0.85); backdrop-filter: blur(24px); border-bottom: 1px solid var(--border); }
.nav-inner { display: flex; justify-content: space-between; align-items: center; }
.logo { display: flex; align-items: center; gap: 8px; font-size: 18px; font-weight: 700; color: var(--text); }
.logo-icon { color: var(--primary); }
.nav-right { display: flex; gap: 20px; }
.nav-link { color: var(--text2); font-size: 14px; }
.stats-row { display: flex; gap: 16px; margin-bottom: 24px; }
.stat-box { flex: 1; text-align: center; padding: 24px; }
.stat-num { font-size: 32px; font-weight: 700; color: var(--primary); }
.stat-lbl { font-size: 14px; color: var(--text3); margin-top: 4px; }
</style>
