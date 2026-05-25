package com.aicodehub.service.impl;

import com.aicodehub.common.BusinessException;
import com.aicodehub.dto.request.CommentRequest;
import com.aicodehub.entity.Comment;
import com.aicodehub.entity.Snippet;
import com.aicodehub.entity.User;
import com.aicodehub.mapper.CommentMapper;
import com.aicodehub.mapper.SnippetMapper;
import com.aicodehub.service.CommentService;
import com.aicodehub.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CommentServiceImpl implements CommentService {

    private final CommentMapper commentMapper;
    private final SnippetMapper snippetMapper;
    private final UserService userService;

    @Override
    @Transactional
    public Long create(CommentRequest request) {
        User currentUser = userService.getCurrentUser();

        // 检查片段是否存在
        Snippet snippet = snippetMapper.selectById(request.getSnippetId());
        if (snippet == null) {
            throw new BusinessException("代码片段不存在");
        }

        Comment comment = new Comment();
        comment.setSnippetId(request.getSnippetId());
        comment.setUserId(currentUser.getId());
        comment.setContent(request.getContent());
        commentMapper.insert(comment);

        // 更新片段评论数
        snippet.setCommentCount(snippet.getCommentCount() + 1);
        snippetMapper.updateById(snippet);

        return comment.getId();
    }

    @Override
    public List<Comment> listBySnippetId(Long snippetId) {
        return commentMapper.selectCommentsBySnippetId(snippetId);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        User currentUser = userService.getCurrentUser();

        Comment comment = commentMapper.selectById(id);
        if (comment == null) {
            throw new BusinessException("评论不存在");
        }
        if (!comment.getUserId().equals(currentUser.getId())) {
            throw new BusinessException(403, "无权删除该评论");
        }
        commentMapper.deleteById(id);

        // 同步减少片段评论数
        Snippet snippet = snippetMapper.selectById(comment.getSnippetId());
        if (snippet != null && snippet.getCommentCount() > 0) {
            snippet.setCommentCount(snippet.getCommentCount() - 1);
            snippetMapper.updateById(snippet);
        }
    }
}
