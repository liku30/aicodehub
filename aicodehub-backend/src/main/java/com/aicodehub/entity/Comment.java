package com.aicodehub.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 评论实体类 → 对应数据库 comment 表
 */
@Data
@TableName("comment")
public class Comment {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 代码片段ID */
    private Long snippetId;

    /** 评论者ID */
    private Long userId;

    /** 评论内容 */
    private String content;

    @TableLogic
    private Integer isDeleted;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    // ===== 非数据库字段 =====
    @TableField(exist = false)
    private String userName;

    @TableField(exist = false)
    private String userAvatar;
}
