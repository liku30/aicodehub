package com.aicodehub.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 收藏实体类 → 对应数据库 favorite 表
 */
@Data
@TableName("favorite")
public class Favorite {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long snippetId;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
