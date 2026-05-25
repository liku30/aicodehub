package com.aicodehub.controller;

import com.aicodehub.common.PageRequest;
import com.aicodehub.common.Result;
import com.aicodehub.dto.request.SnippetCreateRequest;
import com.aicodehub.entity.Snippet;
import com.aicodehub.service.SnippetService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 代码片段控制器
 *
 * 包含：创建、查询、修改、删除、收藏等接口
 */
@RestController
@RequestMapping("/api/snippet")
@RequiredArgsConstructor
public class SnippetController {

    private final SnippetService snippetService;

    /**
     * 创建代码片段
     * POST /api/snippet
     * 需要登录
     */
    @PostMapping
    public Result<Long> create(@Valid @RequestBody SnippetCreateRequest request) {
        Long id = snippetService.create(request);
        return Result.success("创建成功", id);
    }

    /**
     * 获取片段详情
     * GET /api/snippet/{id}
     * 不需要登录（公开片段可以直接看）
     */
    @GetMapping("/{id}")
    public Result<Snippet> getDetail(@PathVariable Long id) {
        Snippet snippet = snippetService.getDetail(id);
        return Result.success(snippet);
    }

    /**
     * 修改片段
     * PUT /api/snippet/{id}
     * 需要登录，且只能修改自己的
     */
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id,
                                @Valid @RequestBody SnippetCreateRequest request) {
        request.setId(id);
        snippetService.update(request);
        return Result.success("修改成功", null);
    }

    /**
     * 删除片段
     * DELETE /api/snippet/{id}
     * 需要登录，且只能删除自己的
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        snippetService.delete(id);
        return Result.success("删除成功", null);
    }

    /**
     * 获取我的片段列表
     * GET /api/snippet/my
     * 需要登录
     */
    @GetMapping("/my")
    public Result<List<Snippet>> getMySnippets(PageRequest pageRequest) {
        List<Snippet> list = snippetService.getMySnippets(pageRequest);
        return Result.success(list);
    }

    /**
     * 探索广场（公开片段）
     * GET /api/snippet/explore
     * 不需要登录
     */
    @GetMapping("/explore")
    public Result<List<Snippet>> explore(PageRequest pageRequest,
                                          @RequestParam(required = false) String language,
                                          @RequestParam(required = false) String keyword) {
        List<Snippet> list = snippetService.getPublicSnippets(pageRequest, language, keyword);
        return Result.success(list);
    }

    /**
     * 收藏/取消收藏
     * POST /api/snippet/{id}/favorite
     * 需要登录
     */
    @PostMapping("/{id}/favorite")
    public Result<Boolean> toggleFavorite(@PathVariable Long id) {
        boolean isFavorited = snippetService.toggleFavorite(id);
        return Result.success(isFavorited ? "已收藏" : "已取消收藏", isFavorited);
    }

    /**
     * 获取我的收藏列表
     * GET /api/snippet/favorites
     * 需要登录
     */
    @GetMapping("/favorites")
    public Result<List<Snippet>> getMyFavorites(PageRequest pageRequest) {
        List<Snippet> list = snippetService.getMyFavorites(pageRequest);
        return Result.success(list);
    }
}
