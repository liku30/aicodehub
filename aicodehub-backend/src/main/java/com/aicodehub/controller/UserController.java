package com.aicodehub.controller;

import com.aicodehub.common.Result;
import com.aicodehub.entity.User;
import com.aicodehub.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 用户控制器
 * 个人中心相关的接口
 */
@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    /**
     * 获取当前登录用户信息
     * GET /api/user/profile
     */
    @GetMapping("/profile")
    public Result<User> getProfile() {
        User user = userService.getCurrentUser();
        user.setPassword(null);  // 不返回密码
        return Result.success(user);
    }

    /**
     * 修改个人信息
     * PUT /api/user/profile
     */
    @PutMapping("/profile")
    public Result<Void> updateProfile(@RequestBody Map<String, String> profile) {
        User user = userService.getCurrentUser();

        if (profile.containsKey("nickname")) {
            user.setNickname(profile.get("nickname"));
        }
        if (profile.containsKey("bio")) {
            user.setBio(profile.get("bio"));
        }
        if (profile.containsKey("githubUrl")) {
            user.setGithubUrl(profile.get("githubUrl"));
        }
        if (profile.containsKey("avatar")) {
            user.setAvatar(profile.get("avatar"));
        }

        userService.updateById(user);
        return Result.success("修改成功", null);
    }
}
