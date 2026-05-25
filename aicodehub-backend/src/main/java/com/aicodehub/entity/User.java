package com.aicodehub.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户实体类 → 对应数据库 user 表
 *
 * @TableName("user") MyBatis-Plus会自动映射到user表
 * 字段名用驼峰命名，MyBatis-Plus会自动转为下划线：
 *   createdAt → created_at
 *   githubUrl → github_url
 */
@Data
@TableName("user")
public class User {

    /** 用户ID，自增主键 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 用户名（唯一） */
    private String username;

    /** 邮箱（唯一） */
    private String email;

    /** 密码（BCrypt加密后存储） */
    private String password;

    /** 昵称 */
    private String nickname;

    /** 头像URL */
    private String avatar;

    /** 个人简介 */
    private String bio;

    /** GitHub地址 */
    private String githubUrl;

    /**
     * 角色：0-普通用户，1-管理员
     * 存储的是数字，使用时用常量对比
     */
    private Integer role;

    /** 状态：0-禁用，1-正常 */
    private Integer status;

    /** 创建时间，插入时自动填充 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /** 更新时间，插入和更新时自动填充 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;

    /**
     * 逻辑删除标记：0-未删除，1-已删除
     * 不需要手动设置，MyBatis-Plus自动处理
     */
    @TableLogic
    private Integer isDeleted;
}
