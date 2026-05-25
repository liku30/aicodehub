package com.aicodehub.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 登录请求参数
 *
 * @NotBlank 注解：不能为null且不能是空字符串
 * 前端发送JSON → Spring自动转成这个对象 → 自动校验
 */
@Data
public class LoginRequest {

    @NotBlank(message = "用户名不能为空")
    private String username;

    @NotBlank(message = "密码不能为空")
    private String password;
}
