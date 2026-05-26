package com.aicodehub.controller;

import com.aicodehub.common.Result;
import com.aicodehub.entity.Snippet;
import com.aicodehub.entity.User;
import com.aicodehub.mapper.SnippetMapper;
import com.aicodehub.mapper.UserMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 管理员控制器
 * 只有 role=1 的管理员才能访问
 */
@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasRole('ADMIN')")
@RequiredArgsConstructor
public class AdminController {

    private final UserMapper userMapper;
    private final SnippetMapper snippetMapper;

    /** 获取所有用户 */
    @GetMapping("/users")
    public Result<List<User>> getAllUsers() {
        List<User> users = userMapper.selectList(
                new LambdaQueryWrapper<User>()
                        .orderByDesc(User::getCreatedAt));
        users.forEach(u -> u.setPassword(null)); // 不返回密码
        return Result.success(users);
    }

    /** 获取所有代码片段 */
    @GetMapping("/snippets")
    public Result<List<Snippet>> getAllSnippets() {
        List<Snippet> snippets = snippetMapper.selectList(
                new LambdaQueryWrapper<Snippet>()
                        .orderByDesc(Snippet::getCreatedAt));
        return Result.success(snippets);
    }

    /** 禁用/启用用户 */
    @PutMapping("/users/{id}/status")
    public Result<Void> toggleUserStatus(@PathVariable Long id,
                                          @RequestBody Map<String, Integer> body) {
        User user = userMapper.selectById(id);
        if (user == null) {
            return Result.error(404, "用户不存在");
        }
        user.setStatus(body.get("status"));
        userMapper.updateById(user);
        return Result.success("操作成功", null);
    }

    /** 删除用户 */
    @DeleteMapping("/users/{id}")
    public Result<Void> deleteUser(@PathVariable Long id) {
        userMapper.deleteById(id);
        return Result.success("删除成功", null);
    }

    /** 删除代码片段 */
    @DeleteMapping("/snippets/{id}")
    public Result<Void> deleteSnippet(@PathVariable Long id) {
        snippetMapper.deleteById(id);
        return Result.success("删除成功", null);
    }

    /** 获取统计数据 */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        long userCount = userMapper.selectCount(null);
        long snippetCount = snippetMapper.selectCount(null);
        Map<String, Object> stats = Map.of(
                "userCount", userCount,
                "snippetCount", snippetCount
        );
        return Result.success(stats);
    }
}
