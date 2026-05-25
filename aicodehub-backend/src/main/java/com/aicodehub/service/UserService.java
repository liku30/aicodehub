package com.aicodehub.service;

import com.aicodehub.dto.request.LoginRequest;
import com.aicodehub.dto.request.RegisterRequest;
import com.aicodehub.dto.response.LoginResponse;
import com.aicodehub.entity.User;

/**
 * 用户服务接口
 *
 * 定义用户相关的业务方法
 * Service层 = 业务逻辑层，介于Controller和Mapper之间
 */
public interface UserService {

    /**
     * 用户注册
     */
    void register(RegisterRequest request);

    /**
     * 用户登录
     * @return 登录响应（包含Token和用户信息）
     */
    LoginResponse login(LoginRequest request);

    /**
     * 根据用户名获取用户信息
     */
    User getByUsername(String username);

    /**
     * 获取当前登录用户信息
     */
    User getCurrentUser();

    /**
     * 更新用户信息
     */
    void updateById(User user);
}
