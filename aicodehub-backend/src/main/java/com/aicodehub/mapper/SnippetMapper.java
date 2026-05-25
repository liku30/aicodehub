package com.aicodehub.mapper;

import com.aicodehub.entity.Snippet;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 代码片段Mapper接口
 */
@Mapper
public interface SnippetMapper extends BaseMapper<Snippet> {

    /**
     * 查询片段列表（关联查询作者信息）
     * 这里需要自定义SQL，因为要JOIN user表获取作者名
     */
    @Select("""
        <script>
        SELECT s.*, u.username as author_name, u.avatar as author_avatar
        FROM snippet s
        LEFT JOIN user u ON s.user_id = u.id
        WHERE s.is_deleted = 0
        <if test="userId != null"> AND s.user_id = #{userId} </if>
        <if test="language != null and language != ''"> AND s.language = #{language} </if>
        <if test="keyword != null and keyword != ''">
            AND (s.title LIKE CONCAT('%', #{keyword}, '%')
                 OR s.description LIKE CONCAT('%', #{keyword}, '%'))
        </if>
        <if test="visibility != null"> AND s.visibility = #{visibility} </if>
        ORDER BY s.created_at DESC
        LIMIT #{offset}, #{pageSize}
        </script>
        """)
    List<Snippet> selectSnippetList(@Param("userId") Long userId,
                                     @Param("language") String language,
                                     @Param("keyword") String keyword,
                                     @Param("visibility") Integer visibility,
                                     @Param("offset") int offset,
                                     @Param("pageSize") int pageSize);

    /**
     * 查询片段详情（关联作者信息）
     */
    @Select("""
        SELECT s.*, u.username as author_name, u.avatar as author_avatar
        FROM snippet s
        LEFT JOIN user u ON s.user_id = u.id
        WHERE s.id = #{id} AND s.is_deleted = 0
        """)
    Snippet selectSnippetDetail(@Param("id") Long id);
}
