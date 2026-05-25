package com.aicodehub.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

/**
 * 片段-标签关联实体类 → 对应数据库 snippet_tag 表
 */
@Data
@TableName("snippet_tag")
public class SnippetTag {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long snippetId;

    private Long tagId;
}
