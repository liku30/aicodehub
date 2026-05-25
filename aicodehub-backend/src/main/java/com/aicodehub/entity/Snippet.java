package com.aicodehub.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 代码片段实体类 → 对应数据库 snippet 表
 */
@Data
@TableName("snippet")
public class Snippet {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 作者ID（关联user表） */
    private Long userId;

    /** 标题 */
    private String title;

    /** 描述 */
    private String description;

    /** 编程语言（java, python, javascript等） */
    private String language;

    /** 代码内容 */
    private String codeContent;

    /** 可见性：0-私有，1-公开 */
    private Integer visibility;

    /** 浏览次数 */
    private Integer viewCount;

    /** 收藏次数 */
    private Integer likeCount;

    /** 评论次数 */
    private Integer commentCount;

    /** 逻辑删除 */
    @TableLogic
    private Integer isDeleted;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;

    /**
     * 非数据库字段：作者用户名
     * 用于查询时关联显示作者信息，不存入snippet表
     */
    @TableField(exist = false)
    private String authorName;

    /** 非数据库字段：作者头像 */
    @TableField(exist = false)
    private String authorAvatar;
}
