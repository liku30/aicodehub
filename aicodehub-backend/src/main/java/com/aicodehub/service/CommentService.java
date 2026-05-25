package com.aicodehub.service;

import com.aicodehub.dto.request.CommentRequest;
import com.aicodehub.entity.Comment;

import java.util.List;

public interface CommentService {
    Long create(CommentRequest request);
    List<Comment> listBySnippetId(Long snippetId);
    void delete(Long id);
}
