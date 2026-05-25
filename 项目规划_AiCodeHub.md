# AiCodeHub - AI智能代码片段管理平台 完整规划

## 一、项目概述

**项目名称：** AiCodeHub（AI代码中心）
**项目简介：** 一个面向开发者的智能代码片段管理平台，支持代码的存储、分类、搜索，并集成AI能力提供代码解释、优化建议和测试用例生成。
**目标用户：** 开发者、学生、技术团队

---

## 二、技术栈选型

### 前端
| 技术 | 版本 | 用途 |
|------|------|------|
| Vue 3 | 3.4+ | 前端框架（Composition API） |
| Vite | 5.x | 构建工具（比Webpack快很多） |
| Element Plus | 2.x | UI组件库（按钮、表单、表格、弹窗等） |
| Vue Router | 4.x | 前端路由 |
| Pinia | 2.x | 状态管理（替代Vuex） |
| Axios | 1.x | HTTP请求 |
| CodeMirror 6 | 6.x | 代码编辑器（支持语法高亮、多语言） |
| Marked + highlight.js | - | Markdown渲染和代码高亮 |

### 后端
| 技术 | 版本 | 用途 |
|------|------|------|
| Spring Boot | 3.2+ | 后端框架 |
| Spring Security | 6.x | 安全框架（认证、授权） |
| MyBatis-Plus | 3.5+ | ORM框架（数据库操作） |
| JWT (jjwt) | 0.12+ | 用户身份认证令牌 |
| Redis | 7.x | 缓存、会话管理、限流 |
| Lombok | - | 简化Java代码 |
| Knife4j | 4.x | API文档（Swagger增强版） |
| Hutool | 5.x | Java工具库 |

### 数据库与存储
| 技术 | 用途 |
|------|------|
| MySQL 8.0 | 主数据库 |
| Redis 7.x | 缓存/会话 |
| 本地文件存储 | 用户头像等（后期可迁移OSS） |

### AI相关
| 技术 | 用途 |
|------|------|
| DeepSeek API | 代码分析、解释、优化建议 |
| OkHttp/WebClient | 调用AI接口 |

### 部署
| 技术 | 用途 |
|------|------|
| Docker | 容器化 |
| Docker Compose | 多容器编排 |
| Nginx | 反向代理、静态资源服务 |
| 阿里云ECS | 云服务器 |

---

## 三、页面设计（共8个核心页面）

### 1. 首页/Landing Page
```
┌─────────────────────────────────────────┐
│  Logo    首页  探索  关于    登录  注册   │
├─────────────────────────────────────────┤
│                                         │
│     AiCodeHub - 智能代码管理中心          │
│     用AI让代码管理更智能                  │
│     [开始使用]  [查看演示]                │
│                                         │
├─────────────────────────────────────────┤
│  ✨ AI智能分析  │  ⚡ 快速搜索  │    │  │
│  自动解释代码    │  标签+全文搜索 │    │  │
├─────────────────────────────────────────┤
│  平台数据统计:  用户数 | 代码片段数 | ... │
├─────────────────────────────────────────┤
│  Footer: 关于我们 | 使用文档 | 联系方式  │
└─────────────────────────────────────────┘
```

### 2. 登录/注册页面
- 登录：用户名+密码 / 邮箱+密码
- 注册：用户名、邮箱、密码、确认密码
- 表单验证（前端+后端双重校验）
- 登录成功后跳转到Dashboard

### 3. Dashboard（主控制台）
```
┌─────────────────────────────────────────┐
│  Logo  首页  我的代码  探索  [+新建片段]  │  用户头像▾ │
├──────┬──────────────────────────────────┤
│ 筛选 │  🔍 搜索代码片段...               │
│------│                                  │
│ 全部 │  ┌─────────────────────────────┐ │
│ 收藏 │  │ #java #排序  快速排序算法    │ │
│ 标签 │  │ def quick_sort(arr): ...    │ │
│  Java│  │ ⭐12  💬3  🕐 2天前  [查看]  │ │
│  Python│ └─────────────────────────────┘ │
│  算法│  ┌─────────────────────────────┐ │
│  ... │  │ #python #web Flask路由配置   │ │
│      │  │ from flask import Flask...  │ │
│ 最近 │  │ ⭐8  💬1  🕐 5天前  [查看]   │ │
│ 修改 │  └─────────────────────────────┘ │
│      │         分页组件                  │
└──────┴──────────────────────────────────┘
```

### 4. 代码片段详情页
```
┌─────────────────────────────────────────┐
│  Logo  首页  我的代码  探索  [+新建片段]  │  用户头像▾ │
├─────────────────────────────────────────┤
│  快速排序算法 - Java实现                  │
│  标签: #java #排序 #算法    ⭐收藏  ✏编辑 │
├─────────────────────────────────────────┤
│ ┌─ 代码区域 ───────────────────────────┐ │
│ │ 1  public int[] quickSort(int[] arr){│ │
│ │ 2      if(arr.length <= 1) return;  │ │
│ │ 3      ...                          │ │
│ │        [复制]  [全屏]  [下载]        │ │
│ └─────────────────────────────────────┘ │
├─────────────────────────────────────────┤
│ ┌─ AI分析 ─────────────────────────────┐ │
│ │ [代码解释] [优化建议] [生成测试]      │ │
│ │                                      │ │
│ │  这段代码实现了快速排序算法...         │ │
│ │  时间复杂度: O(n log n)              │ │
│ │  建议: 可以使用三数取中法优化...      │ │
│ └─────────────────────────────────────┘ │
├─────────────────────────────────────────┤
│  评论区:                                │
│  用户A: 这个实现很清晰！               │
│  [发表评论...]                          │
└─────────────────────────────────────────┘
```

### 5. 新建/编辑代码片段页
```
┌─────────────────────────────────────────┐
│  ← 返回        新建代码片段              │
├─────────────────────────────────────────┤
│  标题: [________________________]       │
│  描述: [________________________]       │
│  语言: [Java ▼]   可见性: [公开 ▼]      │
│  标签: [添加标签...]  #java #排序       │
├─────────────────────────────────────────┤
│ ┌─ 代码编辑器 ─────────────────────────┐ │
│ │                                      │ │
│ │   (CodeMirror 带语法高亮的编辑器)     │ │
│ │                                      │ │
│ │                                      │ │
│ └─────────────────────────────────────┘ │
│                    [保存]  [保存并分析]  │
└─────────────────────────────────────────┘
```

### 6. 探索页（公共广场）
- 展示所有用户公开的代码片段
- 按热度/最新/推荐排序
- 按语言/标签筛选
- 分页加载

### 7. 用户个人中心
- 基本信息编辑（头像、昵称、个人简介、GitHub链接）
- 我的代码片段列表
- 我的收藏
- 统计数据（总片段数、总收藏数、总浏览量）

### 8. 管理员后台（可选扩展）
- 用户管理
- 代码片段管理（审核、删除）
- 系统数据统计

---

## 四、功能模块详细设计

### 模块1：用户系统
| 功能 | 说明 |
|------|------|
| 注册 | 用户名+邮箱+密码，密码BCrypt加密存储 |
| 登录 | 返回JWT Token，有效期7天 |
| Token刷新 | Token快过期时自动刷新 |
| 个人信息管理 | 修改昵称、头像、简介 |
| 权限控制 | 普通用户/管理员两种角色 |

### 模块2：代码片段管理
| 功能 | 说明 |
|------|------|
| 创建片段 | 标题、描述、语言、代码内容、标签、可见性 |
| 编辑片段 | 修改片段信息，保留历史版本（最多10个） |
| 删除片段 | 软删除（可恢复） |
| 查看片段 | 语法高亮显示，行号，复制按钮 |
| 收藏片段 | 收藏/取消收藏，收藏列表 |
| 搜索片段 | 按标题、标签、语言搜索，支持全文检索 |

### 模块3：标签系统
| 功能 | 说明 |
|------|------|
| 创建标签 | 用户可创建自定义标签 |
| 标签分类 | 按颜色区分不同类型 |
| 热门标签 | 显示使用最多的标签 |
| 标签关联 | 一个片段可有多个标签 |

### 模块4：AI分析（第二阶段）
| 功能 | 说明 |
|------|------|
| 代码解释 | AI逐行解释代码逻辑 |
| 优化建议 | 指出性能问题和改进建议 |
| 生成测试 | 自动生成单元测试用例 |
| 自动打标签 | AI分析代码自动推荐标签 |

### 模块5：评论系统
| 功能 | 说明 |
|------|------|
| 发表评论 | 对代码片段发表评论 |
| 评论列表 | 按时间排序显示 |
| 删除评论 | 仅作者可删 |

### 模块6：分享系统（扩展）
| 功能 | 说明 |
|------|------|
| 生成分享链接 | 生成唯一短链接 |
| 无需登录查看 | 通过分享链接可直接查看代码 |

---

## 五、数据库设计

### 表结构总览（共7张表）

#### 1. 用户表 (user)
```sql
CREATE TABLE `user` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    `username`      VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    `email`         VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
    `password`      VARCHAR(255) NOT NULL COMMENT '密码(BCrypt加密)',
    `nickname`      VARCHAR(50) COMMENT '昵称',
    `avatar`        VARCHAR(500) COMMENT '头像URL',
    `bio`           VARCHAR(500) COMMENT '个人简介',
    `github_url`    VARCHAR(200) COMMENT 'GitHub地址',
    `role`          TINYINT DEFAULT 0 COMMENT '角色: 0-普通用户 1-管理员',
    `status`        TINYINT DEFAULT 1 COMMENT '状态: 0-禁用 1-正常',
    `created_at`    DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';
```

#### 2. 代码片段表 (snippet)
```sql
CREATE TABLE `snippet` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '片段ID',
    `user_id`       BIGINT NOT NULL COMMENT '作者ID',
    `title`         VARCHAR(200) NOT NULL COMMENT '标题',
    `description`   VARCHAR(1000) COMMENT '描述',
    `language`      VARCHAR(50) NOT NULL COMMENT '编程语言',
    `code_content`  TEXT NOT NULL COMMENT '代码内容',
    `visibility`    TINYINT DEFAULT 1 COMMENT '可见性: 0-私有 1-公开',
    `view_count`    INT DEFAULT 0 COMMENT '浏览次数',
    `like_count`    INT DEFAULT 0 COMMENT '收藏次数',
    `comment_count` INT DEFAULT 0 COMMENT '评论次数',
    `is_deleted`    TINYINT DEFAULT 0 COMMENT '是否删除: 0-否 1-是',
    `created_at`    DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (`user_id`),
    INDEX idx_language (`language`),
    INDEX idx_created_at (`created_at`),
    FULLTEXT INDEX idx_title_desc (`title`, `description`) WITH PARSER ngram
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码片段表';
```

#### 3. 标签表 (tag)
```sql
CREATE TABLE `tag` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '标签ID',
    `name`          VARCHAR(50) NOT NULL UNIQUE COMMENT '标签名',
    `color`         VARCHAR(20) DEFAULT '#409EFF' COMMENT '标签颜色',
    `snippet_count` INT DEFAULT 0 COMMENT '关联片段数量',
    `created_at`    DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';
```

#### 4. 片段-标签关联表 (snippet_tag)
```sql
CREATE TABLE `snippet_tag` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT,
    `snippet_id`    BIGINT NOT NULL COMMENT '片段ID',
    `tag_id`        BIGINT NOT NULL COMMENT '标签ID',
    UNIQUE KEY uk_snippet_tag (`snippet_id`, `tag_id`),
    INDEX idx_tag_id (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='片段标签关联表';
```

#### 5. 收藏表 (favorite)
```sql
CREATE TABLE `favorite` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id`       BIGINT NOT NULL COMMENT '用户ID',
    `snippet_id`    BIGINT NOT NULL COMMENT '片段ID',
    `created_at`    DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    UNIQUE KEY uk_user_snippet (`user_id`, `snippet_id`),
    INDEX idx_snippet_id (`snippet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收藏表';
```

#### 6. 评论表 (comment)
```sql
CREATE TABLE `comment` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT,
    `snippet_id`    BIGINT NOT NULL COMMENT '片段ID',
    `user_id`       BIGINT NOT NULL COMMENT '评论者ID',
    `content`       VARCHAR(1000) NOT NULL COMMENT '评论内容',
    `is_deleted`    TINYINT DEFAULT 0 COMMENT '是否删除',
    `created_at`    DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
    INDEX idx_snippet_id (`snippet_id`),
    INDEX idx_user_id (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评论表';
```

#### 7. AI分析结果表 (ai_analysis)
```sql
CREATE TABLE `ai_analysis` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT,
    `snippet_id`    BIGINT NOT NULL COMMENT '片段ID',
    `analysis_type` VARCHAR(20) NOT NULL COMMENT '分析类型: explain/optimize/test',
    `result`        TEXT COMMENT '分析结果(Markdown格式)',
    `created_at`    DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '分析时间',
    INDEX idx_snippet_type (`snippet_id`, `analysis_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI分析结果表';
```

### 表关系图
```
user ──1:N──> snippet (一个用户有多个代码片段)
user ──1:N──> comment (一个用户有多个评论)
user ──1:N──> favorite (一个用户收藏多个片段)
snippet ──1:N──> comment (一个片段有多个评论)
snippet ──1:N──> ai_analysis (一个片段有多条AI分析)
snippet ──M:N──> tag (通过snippet_tag关联)
snippet ──1:N──> favorite (一个片段可被多人收藏)
```

---

## 六、后端API设计（核心接口）

### 用户相关
```
POST   /api/auth/register          # 注册
POST   /api/auth/login             # 登录
POST   /api/auth/refresh           # 刷新Token
GET    /api/user/profile           # 获取个人信息
PUT    /api/user/profile           # 修改个人信息
```

### 代码片段相关
```
POST   /api/snippet                # 创建片段
GET    /api/snippet/{id}           # 获取片段详情
PUT    /api/snippet/{id}           # 修改片段
DELETE /api/snippet/{id}           # 删除片段
GET    /api/snippet/list           # 获取片段列表(分页)
GET    /api/snippet/my             # 获取我的片段
GET    /api/snippet/explore        # 探索广场(公开片段)
POST   /api/snippet/{id}/favorite  # 收藏/取消收藏
```

### 标签相关
```
GET    /api/tag/list               # 获取所有标签
POST   /api/tag                    # 创建标签
GET    /api/tag/hot                # 热门标签
```

### 评论相关
```
POST   /api/comment                # 发表评论
GET    /api/comment/list/{snippetId} # 获取片段评论
DELETE /api/comment/{id}           # 删除评论
```

### AI分析相关
```
POST   /api/ai/explain/{snippetId}   # 代码解释
POST   /api/ai/optimize/{snippetId}  # 优化建议
POST   /api/ai/test/{snippetId}      # 生成测试
GET    /api/ai/result/{snippetId}    # 获取历史分析结果
```

---

## 七、后端项目结构

```
aicodehub-backend/
├── src/main/java/com/aicodehub/
│   ├── AiCodeHubApplication.java          # 启动类
│   ├── config/                            # 配置类
│   │   ├── SecurityConfig.java            # Spring Security配置
│   │   ├── CorsConfig.java                # 跨域配置
│   │   ├── MyBatisPlusConfig.java         # MyBatis-Plus配置
│   │   ├── RedisConfig.java               # Redis配置
│   │   └── SwaggerConfig.java             # API文档配置
│   ├── controller/                        # 控制器层(接收请求)
│   │   ├── AuthController.java            # 认证接口
│   │   ├── SnippetController.java         # 代码片段接口
│   │   ├── TagController.java             # 标签接口
│   │   ├── CommentController.java         # 评论接口
│   │   ├── AiController.java              # AI分析接口
│   │   └── UserController.java            # 用户接口
│   ├── service/                           # 服务层(业务逻辑)
│   │   ├── UserService.java
│   │   ├── SnippetService.java
│   │   ├── TagService.java
│   │   ├── CommentService.java
│   │   ├── AiService.java
│   │   └── impl/                          # 服务实现
│   │       ├── UserServiceImpl.java
│   │       ├── SnippetServiceImpl.java
│   │       ├── TagServiceImpl.java
│   │       ├── CommentServiceImpl.java
│   │       └── AiServiceImpl.java
│   ├── mapper/                            # 数据访问层(MyBatis)
│   │   ├── UserMapper.java
│   │   ├── SnippetMapper.java
│   │   ├── TagMapper.java
│   │   ├── SnippetTagMapper.java
│   │   ├── CommentMapper.java
│   │   ├── FavoriteMapper.java
│   │   └── AiAnalysisMapper.java
│   ├── entity/                            # 实体类(对应数据库表)
│   │   ├── User.java
│   │   ├── Snippet.java
│   │   ├── Tag.java
│   │   ├── SnippetTag.java
│   │   ├── Comment.java
│   │   ├── Favorite.java
│   │   └── AiAnalysis.java
│   ├── dto/                               # 数据传输对象(接口入参/返回)
│   │   ├── request/
│   │   │   ├── LoginRequest.java
│   │   │   ├── RegisterRequest.java
│   │   │   ├── SnippetCreateRequest.java
│   │   │   └── CommentRequest.java
│   │   └── response/
│   │       ├── LoginResponse.java
│   │       ├── SnippetResponse.java
│   │       └── PageResponse.java
│   ├── common/                            # 公共模块
│   │   ├── Result.java                    # 统一返回格式
│   │   ├── PageRequest.java               # 分页参数
│   │   ├── GlobalExceptionHandler.java    # 全局异常处理
│   │   └── Constants.java                 # 常量
│   ├── security/                          # 安全相关
│   │   ├── JwtUtil.java                   # JWT工具类
│   │   ├── JwtAuthenticationFilter.java   # JWT过滤器
│   │   └── UserDetailsServiceImpl.java    # 用户认证服务
│   └── util/                              # 工具类
│       ├── AiClient.java                  # DeepSeek API调用客户端
│       └── FileUtil.java                  # 文件工具
├── src/main/resources/
│   ├── application.yml                    # 主配置文件
│   ├── application-dev.yml                # 开发环境配置
│   ├── application-prod.yml               # 生产环境配置
│   └── mapper/                            # MyBatis XML映射文件
│       ├── SnippetMapper.xml
│       └── ...
├── pom.xml                                # Maven依赖管理
├── Dockerfile                             # Docker构建文件
└── sql/
    └── init.sql                           # 数据库初始化脚本
```

---

## 八、前端项目结构

```
aicodehub-frontend/
├── public/
│   └── index.html
├── src/
│   ├── main.js                            # 入口文件
│   ├── App.vue                            # 根组件
│   ├── api/                               # API请求模块
│   │   ├── index.js                       # Axios配置(拦截器、基地址)
│   │   ├── user.js                        # 用户相关API
│   │   ├── snippet.js                     # 代码片段相关API
│   │   ├── tag.js                         # 标签相关API
│   │   ├── comment.js                     # 评论相关API
│   │   └── ai.js                          # AI分析相关API
│   ├── router/                            # 路由配置
│   │   └── index.js
│   ├── store/                             # 状态管理(Pinia)
│   │   ├── user.js                        # 用户状态
│   │   └── snippet.js                     # 片段状态
│   ├── views/                             # 页面组件
│   │   ├── Home.vue                       # 首页
│   │   ├── Login.vue                      # 登录页
│   │   ├── Register.vue                   # 注册页
│   │   ├── Dashboard.vue                  # 主控制台
│   │   ├── SnippetDetail.vue              # 片段详情页
│   │   ├── SnippetEditor.vue              # 新建/编辑片段页
│   │   ├── Explore.vue                    # 探索广场
│   │   └── Profile.vue                    # 个人中心
│   ├── components/                        # 公共组件
│   │   ├── layout/
│   │   │   ├── AppHeader.vue              # 顶部导航栏
│   │   │   └── AppFooter.vue              # 页脚
│   │   ├── snippet/
│   │   │   ├── SnippetCard.vue            # 片段卡片
│   │   │   ├── CodeEditor.vue             # 代码编辑器(CodeMirror封装)
│   │   │   ├── CodeViewer.vue             # 代码查看器(高亮显示)
│   │   │   └── AiAnalysisPanel.vue        # AI分析面板
│   │   ├── common/
│   │   │   ├── SearchBar.vue              # 搜索栏
│   │   │   ├── TagSelector.vue            # 标签选择器
│   │   │   └── Pagination.vue             # 分页组件
│   │   └── comment/
│   │       ├── CommentList.vue            # 评论列表
│   │       └── CommentForm.vue            # 评论表单
│   ├── utils/                             # 工具函数
│   │   ├── auth.js                        # Token管理
│   │   └── language.js                    # 编程语言映射
│   └── assets/                            # 静态资源
│       └── styles/
│           └── global.css
├── index.html
├── vite.config.js                         # Vite配置
├── package.json
└── Dockerfile
```

---

## 九、开发步骤（分阶段）

### 第一阶段：项目搭建 + 核心功能（预计2-3周）

**第1步：环境搭建（1天）**
- 安装JDK 17、Maven、Node.js 18+、MySQL 8.0、Redis
- 创建Spring Boot项目，引入依赖
- 创建Vue 3项目(Vite)，引入Element Plus
- 配置好前后端联调环境

**第2步：数据库和后端基础（2-3天）**
- 执行SQL建表
- 编写实体类(Entity)
- 编写Mapper接口
- 配置MyBatis-Plus
- 编写统一返回格式(Result)

**第3步：用户系统（2-3天）**
- 注册接口（密码加密、参数校验）
- 登录接口（JWT生成、验证）
- Spring Security配置
- 前端登录/注册页面
- Token存储和自动携带

**第4步：代码片段CRUD（3-4天）**
- 后端：创建、查询、修改、删除接口
- 分页查询、条件筛选
- 前端：片段列表页、详情页、编辑页
- CodeMirror代码编辑器集成

**第5步：标签系统（1-2天）**
- 标签的增删查
- 片段关联标签
- 按标签筛选片段

**第6步：前后端联调（2天）**
- 配置代理解决跨域
- 统一异常处理
- 接口调试

### 第二阶段：增强功能 + 部署上线（预计1-2周）

**第7步：收藏 + 评论（2天）**
- 收藏/取消收藏
- 评论的发表和展示

**第8步：探索广场（1天）**
- 公开片段展示
- 排序和筛选

**第9步：Docker部署（2天）**
- 编写Dockerfile
- 编写docker-compose.yml
- 云服务器环境配置
- Nginx反向代理配置
- 域名和HTTPS配置

### 第三阶段：AI功能（预计1周）

**第10步：接入DeepSeek API（3-4天）**
- 编写AI客户端调用代码
- 代码解释功能
- 优化建议功能
- 生成测试用例功能
- 前端AI分析面板

---

## 十、部署方案详解

### 服务器选购建议
| 配置 | 价格(月) | 适合 |
|------|---------|------|
| 2核2G 40G | ~30元 | 开发测试够用 |
| 2核4G 60G | ~60-100元 | 正式上线推荐（推荐） |
| 4核8G 100G | ~200元+ | 流量大时升级 |

推荐：阿里云或腾讯云，新用户有优惠，学生认证更便宜。

### 部署架构
```
                    用户请求
                       │
                       ▼
              ┌─────────────────┐
              │    Nginx:80     │  ← 反向代理 + 静态资源
              │  (前端Vue打包)   │
              └────────┬────────┘
                       │
              ┌────────▼────────┐
              │  Spring Boot    │  ← 后端API
              │    :8080        │
              └────────┬────────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
      ┌───────┐  ┌──────────┐  ┌───────┐
      │ MySQL │  │  Redis   │  │ Files │
      │ :3306 │  │  :6379   │  │ /data │
      └───────┘  └──────────┘  └───────┘
```

### Docker Compose 部署（一键启动所有服务）
```yaml
# docker-compose.yml 大致结构
services:
  nginx:         # 前端 + 反向代理
  backend:       # Spring Boot应用
  mysql:         # 数据库
  redis:         # 缓存
```

一条命令启动所有服务：`docker-compose up -d`

---

## 十一、统一返回格式设计

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "list": [...],
        "total": 100,
        "pageNum": 1,
        "pageSize": 10
    }
}
```

错误时：
```json
{
    "code": 40001,
    "message": "用户名已存在",
    "data": null
}
```

---

## 十二、创新点总结（简历可用）

1. **AI驱动的代码分析**：集成DeepSeek大模型，提供智能代码解释和优化建议
2. **智能标签系统**：AI自动识别代码类型并推荐标签
3. **全文检索**：MySQL全文索引支持中文搜索
4. **现代化部署**：Docker容器化 + Nginx反向代理，完整DevOps流程
5. **前后端分离架构**：Vue 3 + Spring Boot，RESTful API设计
6. **安全体系**：JWT无状态认证 + Spring Security + BCrypt密码加密
7. **缓存优化**：Redis缓存热门数据，提升响应速度
