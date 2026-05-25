package com.aicodehub.controller;

import com.aicodehub.common.Result;
import com.aicodehub.dto.request.LoginRequest;
import com.aicodehub.dto.request.RegisterRequest;
import com.aicodehub.dto.response.LoginResponse;
import com.aicodehub.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 认证控制器
 *
 * 处理：注册、登录
 * 这两个接口在Security配置中被放行（不需要Token就能访问）
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;

    /**
     * 注册
     * POST /api/auth/register
     *
     * 请求体示例：
     * {
     *   "username": "zhangsan",
     *   "email": "zhangsan@example.com",
     *   "password": "123456"
     * }
     *
     * @Valid 注解触发参数校验（在RegisterRequest中定义的规则）
     */
    @PostMapping("/register")
    public Result<Void> register(@Valid @RequestBody RegisterRequest request) {
        userService.register(request);
        return Result.success("注册成功", null);
    }

    /**
     * 登录
     * POST /api/auth/login
     *
     * 请求体示例：
     * {
     *   "username": "zhangsan",
     *   "password": "123456"
     * }
     *
     * 返回示例：
     * {
     *   "code": 200,
     *   "message": "success",
     *   "data": {
     *     "token": "eyJhbGciOiJIUzI1...",
     *     "userId": 1,
     *     "username": "zhangsan",
     *     "nickname": "张三",
     *     "avatar": null
     *   }
     * }
     */
    @PostMapping("/login")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        LoginResponse response = userService.login(request);
        return Result.success("登录成功", response);
    }
}
