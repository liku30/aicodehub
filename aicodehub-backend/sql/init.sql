-- ============================================
-- AiCodeHub 数据库初始化脚本
-- 使用方法：
--   1. 先创建数据库：CREATE DATABASE aicodehub;
--   2. 然后执行本脚本：mysql -u root -p aicodehub < init.sql
-- ============================================

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS aicodehub
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE aicodehub;

-- ============================================
-- 1. 用户表
-- ============================================
CREATE TABLE IF NOT EXISTS `user` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    `username`      VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    `email`         VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
    `password`      VARCHAR(255) NOT NULL COMMENT '密码(BCrypt加密)',
    `nickname`      VARCHAR(50) DEFAULT NULL COMMENT '昵称',
    `avatar`        VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    `bio`           VARCHAR(500) DEFAULT NULL COMMENT '个人简介',
    `github_url`    VARCHAR(200) DEFAULT NULL COMMENT 'GitHub地址',
    `role`          TINYINT NOT NULL DEFAULT 0 COMMENT '角色: 0-普通用户 1-管理员',
    `status`        TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0-禁用 1-正常',
    `is_deleted`    TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除: 0-未删除 1-已删除',
    `created_at`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ============================================
-- 2. 代码片段表
-- ============================================
CREATE TABLE IF NOT EXISTS `snippet` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '片段ID',
    `user_id`       BIGINT NOT NULL COMMENT '作者ID',
    `title`         VARCHAR(200) NOT NULL COMMENT '标题',
    `description`   VARCHAR(1000) DEFAULT NULL COMMENT '描述',
    `language`      VARCHAR(50) NOT NULL COMMENT '编程语言',
    `code_content`  MEDIUMTEXT NOT NULL COMMENT '代码内容',
    `visibility`    TINYINT NOT NULL DEFAULT 1 COMMENT '可见性: 0-私有 1-公开',
    `view_count`    INT NOT NULL DEFAULT 0 COMMENT '浏览次数',
    `like_count`    INT NOT NULL DEFAULT 0 COMMENT '收藏次数',
    `comment_count` INT NOT NULL DEFAULT 0 COMMENT '评论次数',
    `is_deleted`    TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
    `created_at`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_language` (`language`),
    INDEX `idx_created_at` (`created_at`),
    FULLTEXT INDEX `idx_title_desc` (`title`, `description`) WITH PARSER ngram
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码片段表';

-- ============================================
-- 3. 标签表
-- ============================================
CREATE TABLE IF NOT EXISTS `tag` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '标签ID',
    `name`          VARCHAR(50) NOT NULL UNIQUE COMMENT '标签名',
    `color`         VARCHAR(20) NOT NULL DEFAULT '#409EFF' COMMENT '标签颜色',
    `snippet_count` INT NOT NULL DEFAULT 0 COMMENT '关联片段数量',
    `created_at`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='标签表';

-- ============================================
-- 4. 片段-标签关联表
-- ============================================
CREATE TABLE IF NOT EXISTS `snippet_tag` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT,
    `snippet_id`    BIGINT NOT NULL COMMENT '片段ID',
    `tag_id`        BIGINT NOT NULL COMMENT '标签ID',
    UNIQUE KEY `uk_snippet_tag` (`snippet_id`, `tag_id`),
    INDEX `idx_tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='片段标签关联表';

-- ============================================
-- 5. 收藏表
-- ============================================
CREATE TABLE IF NOT EXISTS `favorite` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id`       BIGINT NOT NULL COMMENT '用户ID',
    `snippet_id`    BIGINT NOT NULL COMMENT '片段ID',
    `created_at`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    UNIQUE KEY `uk_user_snippet` (`user_id`, `snippet_id`),
    INDEX `idx_snippet_id` (`snippet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='收藏表';

-- ============================================
-- 6. 评论表
-- ============================================
CREATE TABLE IF NOT EXISTS `comment` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT,
    `snippet_id`    BIGINT NOT NULL COMMENT '片段ID',
    `user_id`       BIGINT NOT NULL COMMENT '评论者ID',
    `content`       VARCHAR(1000) NOT NULL COMMENT '评论内容',
    `is_deleted`    TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
    `created_at`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
    INDEX `idx_snippet_id` (`snippet_id`),
    INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='评论表';

-- ============================================
-- 7. AI分析结果表
-- ============================================
CREATE TABLE IF NOT EXISTS `ai_analysis` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT,
    `snippet_id`    BIGINT NOT NULL COMMENT '片段ID',
    `analysis_type` VARCHAR(20) NOT NULL COMMENT '分析类型: explain/optimize/test',
    `result`        MEDIUMTEXT DEFAULT NULL COMMENT '分析结果(Markdown格式)',
    `created_at`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '分析时间',
    INDEX `idx_snippet_type` (`snippet_id`, `analysis_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI分析结果表';

-- ============================================
-- 插入初始数据：一些常用标签
-- ============================================
INSERT INTO `tag` (`name`, `color`, `snippet_count`) VALUES
    ('Java', '#ED8B00', 0),
    ('Python', '#3776AB', 0),
    ('JavaScript', '#F7DF1E', 0),
    ('TypeScript', '#3178C6', 0),
    ('Go', '#00ADD8', 0),
    ('Rust', '#DEA584', 0),
    ('C++', '#00599C', 0),
    ('算法', '#E74C3C', 0),
    ('数据结构', '#9B59B6', 0),
    ('Spring Boot', '#6DB33F', 0),
    ('Vue', '#42B883', 0),
    ('React', '#61DAFB', 0),
    ('数据库', '#336791', 0),
    ('工具函数', '#FF6B6B', 0),
    ('设计模式', '#2ECC71', 0);

-- 完成！
SELECT 'Database initialized successfully!' AS message;
