package com.aicodehub.mapper;

import com.aicodehub.entity.Comment;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CommentMapper extends BaseMapper<Comment> {

    /**
     * 查询片段的评论列表（关联查询评论者信息）
     */
    @Select("""
        SELECT c.*, u.username as user_name, u.avatar as user_avatar
        FROM comment c
        LEFT JOIN user u ON c.user_id = u.id
        WHERE c.snippet_id = #{snippetId} AND c.is_deleted = 0
        ORDER BY c.created_at DESC
        """)
    List<Comment> selectCommentsBySnippetId(@Param("snippetId") Long snippetId);
}
