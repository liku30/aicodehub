package com.aicodehub.service;

import com.aicodehub.common.PageRequest;
import com.aicodehub.dto.request.SnippetCreateRequest;
import com.aicodehub.entity.Snippet;

import java.util.List;

/**
 * 代码片段服务接口
 */
public interface SnippetService {

    /** 创建片段 */
    Long create(SnippetCreateRequest request);

    /** 获取片段详情 */
    Snippet getDetail(Long id);

    /** 修改片段 */
    void update(SnippetCreateRequest request);

    /** 删除片段 */
    void delete(Long id);

    /** 获取我的片段列表 */
    List<Snippet> getMySnippets(PageRequest pageRequest);

    /** 获取公开片段列表（探索广场） */
    List<Snippet> getPublicSnippets(PageRequest pageRequest, String language, String keyword);

    /** 收藏/取消收藏 */
    boolean toggleFavorite(Long snippetId);

    /** 获取我的收藏列表 */
    List<Snippet> getMyFavorites(PageRequest pageRequest);
}
