package com.aicodehub.controller;

import com.aicodehub.common.Result;
import com.aicodehub.dto.request.CommentRequest;
import com.aicodehub.entity.Comment;
import com.aicodehub.service.CommentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 评论控制器
 */
@RestController
@RequestMapping("/api/comment")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;

    /** 发表评论（需要登录） */
    @PostMapping
    public Result<Long> create(@Valid @RequestBody CommentRequest request) {
        Long id = commentService.create(request);
        return Result.success("评论成功", id);
    }

    /** 获取片段的评论列表（不需要登录） */
    @GetMapping("/list/{snippetId}")
    public Result<List<Comment>> list(@PathVariable Long snippetId) {
        return Result.success(commentService.listBySnippetId(snippetId));
    }

    /** 删除评论（需要登录，只能删自己的） */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        commentService.delete(id);
        return Result.success("删除成功", null);
    }
}
