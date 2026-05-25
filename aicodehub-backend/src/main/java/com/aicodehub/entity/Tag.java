package com.aicodehub.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 标签实体类 → 对应数据库 tag 表
 */
@Data
@TableName("tag")
public class Tag {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 标签名（唯一） */
    private String name;

    /** 标签颜色 */
    private String color;

    /** 关联的代码片段数量 */
    private Integer snippetCount;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
