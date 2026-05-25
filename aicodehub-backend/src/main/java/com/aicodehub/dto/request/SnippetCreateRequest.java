package com.aicodehub.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

/**
 * 创建/编辑代码片段请求参数
 */
@Data
public class SnippetCreateRequest {

    private Long id;  // 编辑时传ID，新建时不传

    @NotBlank(message = "标题不能为空")
    private String title;

    private String description;

    @NotBlank(message = "编程语言不能为空")
    private String language;

    @NotBlank(message = "代码内容不能为空")
    private String codeContent;

    /** 可见性：0-私有，1-公开 */
    @NotNull(message = "可见性不能为空")
    private Integer visibility;

    /** 标签ID列表 */
    private List<Long> tagIds;
}
