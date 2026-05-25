package com.aicodehub.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 发表评论请求参数
 */
@Data
public class CommentRequest {

    @NotNull(message = "代码片段ID不能为空")
    private Long snippetId;

    @NotBlank(message = "评论内容不能为空")
    private String content;
}
