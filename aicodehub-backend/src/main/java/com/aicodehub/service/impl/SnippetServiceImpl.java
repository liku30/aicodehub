package com.aicodehub.service.impl;

import com.aicodehub.common.BusinessException;
import com.aicodehub.common.PageRequest;
import com.aicodehub.dto.request.SnippetCreateRequest;
import com.aicodehub.entity.Favorite;
import com.aicodehub.entity.Snippet;
import com.aicodehub.entity.SnippetTag;
import com.aicodehub.entity.User;
import com.aicodehub.mapper.FavoriteMapper;
import com.aicodehub.mapper.SnippetMapper;
import com.aicodehub.mapper.SnippetTagMapper;
import com.aicodehub.service.SnippetService;
import com.aicodehub.service.UserService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 代码片段服务实现类
 *
 * 核心业务逻辑都在这里
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SnippetServiceImpl implements SnippetService {

    private final SnippetMapper snippetMapper;
    private final SnippetTagMapper snippetTagMapper;
    private final FavoriteMapper favoriteMapper;
    private final UserService userService;

    /**
     * 创建片段流程：
     * 1. 获取当前登录用户
     * 2. 保存片段基本信息
     * 3. 保存标签关联关系
     */
    @Override
    @Transactional
    public Long create(SnippetCreateRequest request) {
        User currentUser = userService.getCurrentUser();

        // 构建片段对象
        Snippet snippet = new Snippet();
        snippet.setUserId(currentUser.getId());
        snippet.setTitle(request.getTitle());
        snippet.setDescription(request.getDescription());
        snippet.setLanguage(request.getLanguage().toLowerCase());
        snippet.setCodeContent(request.getCodeContent());
        snippet.setVisibility(request.getVisibility());
        snippet.setViewCount(0);
        snippet.setLikeCount(0);
        snippet.setCommentCount(0);

        // 保存到数据库
        snippetMapper.insert(snippet);

        // 保存标签关联
        if (request.getTagIds() != null && !request.getTagIds().isEmpty()) {
            for (Long tagId : request.getTagIds()) {
                SnippetTag snippetTag = new SnippetTag();
                snippetTag.setSnippetId(snippet.getId());
                snippetTag.setTagId(tagId);
                snippetTagMapper.insert(snippetTag);
            }
        }

        log.info("代码片段创建成功: id={}, title={}", snippet.getId(), request.getTitle());
        return snippet.getId();
    }

    /**
     * 获取片段详情：
     * 1. 查询片段（关联作者信息）
     * 2. 如果是别人的公开片段，浏览次数+1
     * 3. 检查权限（私有片段只有作者能看）
     */
    @Override
    public Snippet getDetail(Long id) {
        Snippet snippet = snippetMapper.selectSnippetDetail(id);

        if (snippet == null) {
            throw new BusinessException("代码片段不存在");
        }

        // 私有片段：只有作者自己能看，其他人统一返回"不存在"（避免泄露存在性）
        if (snippet.getVisibility() == 0) {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth == null || !auth.isAuthenticated()
                    || "anonymousUser".equals(auth.getPrincipal())) {
                throw new BusinessException("代码片段不存在");
            }
            User currentUser = userService.getByUsername(auth.getName());
            if (currentUser == null || !currentUser.getId().equals(snippet.getUserId())) {
                throw new BusinessException("代码片段不存在");
            }
        }

        // 浏览次数+1
        snippet.setViewCount(snippet.getViewCount() + 1);
        snippetMapper.updateById(snippet);

        return snippet;
    }

    @Override
    @Transactional
    public void update(SnippetCreateRequest request) {
        User currentUser = userService.getCurrentUser();

        Snippet existing = snippetMapper.selectById(request.getId());
        if (existing == null) {
            throw new BusinessException("代码片段不存在");
        }

        // 只能修改自己的
        if (!existing.getUserId().equals(currentUser.getId())) {
            throw new BusinessException(403, "无权修改该片段");
        }

        // 更新字段
        existing.setTitle(request.getTitle());
        existing.setDescription(request.getDescription());
        existing.setLanguage(request.getLanguage().toLowerCase());
        existing.setCodeContent(request.getCodeContent());
        existing.setVisibility(request.getVisibility());
        snippetMapper.updateById(existing);

        // 更新标签关联：先删除旧的，再插入新的
        snippetTagMapper.delete(
                new LambdaQueryWrapper<SnippetTag>().eq(SnippetTag::getSnippetId, request.getId()));
        if (request.getTagIds() != null) {
            for (Long tagId : request.getTagIds()) {
                SnippetTag snippetTag = new SnippetTag();
                snippetTag.setSnippetId(request.getId());
                snippetTag.setTagId(tagId);
                snippetTagMapper.insert(snippetTag);
            }
        }
    }

    @Override
    @Transactional
    public void delete(Long id) {
        User currentUser = userService.getCurrentUser();

        Snippet snippet = snippetMapper.selectById(id);
        if (snippet == null) {
            throw new BusinessException("代码片段不存在");
        }
        if (!snippet.getUserId().equals(currentUser.getId())) {
            throw new BusinessException(403, "无权删除该片段");
        }

        snippetMapper.deleteById(id);  // 逻辑删除（isDeleted=1）
    }

    @Override
    public List<Snippet> getMySnippets(PageRequest pageRequest) {
        User currentUser = userService.getCurrentUser();
        return snippetMapper.selectSnippetList(
                currentUser.getId(), null, null, null,
                pageRequest.getOffset(), pageRequest.getPageSize());
    }

    @Override
    public List<Snippet> getPublicSnippets(PageRequest pageRequest, String language, String keyword) {
        return snippetMapper.selectSnippetList(
                null, language, keyword, 1,  // visibility=1 表示公开
                pageRequest.getOffset(), pageRequest.getPageSize());
    }

    /**
     * 收藏/取消收藏（切换）
     */
    @Override
    @Transactional
    public boolean toggleFavorite(Long snippetId) {
        User currentUser = userService.getCurrentUser();

        // 检查片段是否存在
        Snippet snippet = snippetMapper.selectById(snippetId);
        if (snippet == null) {
            throw new BusinessException("代码片段不存在");
        }

        // 检查是否已收藏
        Favorite existing = favoriteMapper.selectOne(
                new LambdaQueryWrapper<Favorite>()
                        .eq(Favorite::getUserId, currentUser.getId())
                        .eq(Favorite::getSnippetId, snippetId));

        if (existing != null) {
            // 已收藏 → 取消收藏
            favoriteMapper.deleteById(existing.getId());
            snippet.setLikeCount(Math.max(0, snippet.getLikeCount() - 1));
            snippetMapper.updateById(snippet);
            return false;
        } else {
            // 未收藏 → 收藏
            Favorite favorite = new Favorite();
            favorite.setUserId(currentUser.getId());
            favorite.setSnippetId(snippetId);
            favoriteMapper.insert(favorite);
            snippet.setLikeCount(snippet.getLikeCount() + 1);
            snippetMapper.updateById(snippet);
            return true;
        }
    }

    @Override
    public List<Snippet> getMyFavorites(PageRequest pageRequest) {
        User currentUser = userService.getCurrentUser();

        // 先查出收藏的片段ID列表（用MyBatis-Plus的last方法做分页，参数已校验为int类型）
        List<Favorite> favorites = favoriteMapper.selectList(
                new LambdaQueryWrapper<Favorite>()
                        .eq(Favorite::getUserId, currentUser.getId())
                        .orderByDesc(Favorite::getCreatedAt)
                        .last("LIMIT " + pageRequest.getOffset() + ", " + pageRequest.getPageSize()));

        if (favorites.isEmpty()) {
            return List.of();
        }

        // 根据ID列表查询片段详情，保持收藏顺序
        List<Long> snippetIds = favorites.stream().map(Favorite::getSnippetId).toList();
        List<Snippet> snippets = snippetMapper.selectBatchIds(snippetIds);

        // 按收藏顺序排列（selectBatchIds不保证顺序）
        return snippets.stream()
                .sorted((a, b) -> {
                    int indexA = snippetIds.indexOf(a.getId());
                    int indexB = snippetIds.indexOf(b.getId());
                    return Integer.compare(indexA, indexB);
                })
                .toList();
    }
}
