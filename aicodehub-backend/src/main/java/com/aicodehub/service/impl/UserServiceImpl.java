package com.aicodehub.service.impl;

import com.aicodehub.common.BusinessException;
import com.aicodehub.dto.request.LoginRequest;
import com.aicodehub.dto.request.RegisterRequest;
import com.aicodehub.dto.response.LoginResponse;
import com.aicodehub.entity.User;
import com.aicodehub.mapper.UserMapper;
import com.aicodehub.security.JwtUtil;
import com.aicodehub.service.UserService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 用户服务实现类
 *
 * 这里实现了所有用户相关的业务逻辑
 * @RequiredArgsConstructor = Lombok自动生成构造函数，注入依赖
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;

    /**
     * 注册流程：
     * 1. 检查用户名是否已存在
     * 2. 检查邮箱是否已被注册
     * 3. 密码加密
     * 4. 保存到数据库
     */
    @Override
    @Transactional  // 事务：保证操作的原子性（要么全成功，要么全失败）
    public void register(RegisterRequest request) {
        // 1. 检查用户名是否已存在
        Long count = userMapper.selectCount(
                new LambdaQueryWrapper<User>().eq(User::getUsername, request.getUsername()));
        if (count > 0) {
            throw new BusinessException("用户名已存在");
        }

        // 2. 检查邮箱是否已被注册
        count = userMapper.selectCount(
                new LambdaQueryWrapper<User>().eq(User::getEmail, request.getEmail()));
        if (count > 0) {
            throw new BusinessException("邮箱已被注册");
        }

        // 3. 构建用户对象
        User user = new User();
        user.setUsername(request.getUsername());
        user.setEmail(request.getEmail());
        // 密码加密：BCrypt算法，每次加密结果不同（加了随机盐），但都能验证
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setNickname(request.getUsername());  // 默认昵称=用户名
        user.setRole(0);   // 普通用户
        user.setStatus(1); // 正常状态

        // 4. 保存到数据库
        userMapper.insert(user);

        log.info("用户注册成功: {}", request.getUsername());
    }

    /**
     * 登录流程：
     * 1. 用Spring Security的AuthenticationManager验证用户名密码
     * 2. 验证通过 → 生成JWT Token
     * 3. 返回Token + 用户信息
     */
    @Override
    public LoginResponse login(LoginRequest request) {
        // 1. 认证（会自动调用UserDetailsServiceImpl查询数据库，并比对密码）
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(), request.getPassword())
        );

        // 2. 认证通过，获取用户信息
        SecurityContextHolder.getContext().setAuthentication(authentication);
        User user = getByUsername(request.getUsername());

        // 3. 生成JWT Token
        String token = jwtUtil.generateToken(user.getId(), user.getUsername());

        // 4. 构建返回对象
        return LoginResponse.builder()
                .token(token)
                .userId(user.getId())
                .username(user.getUsername())
                .nickname(user.getNickname())
                .avatar(user.getAvatar())
                .role(user.getRole())
                .build();
    }

    @Override
    public User getByUsername(String username) {
        return userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getUsername, username));
    }

    /**
     * 获取当前登录用户
     * 从Spring Security上下文中获取当前用户名 → 查数据库获取完整信息
     */
    @Override
    public User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new BusinessException(401, "请先登录");
        }
        String username = authentication.getName();
        User user = getByUsername(username);
        if (user == null) {
            throw new BusinessException(401, "用户不存在");
        }
        return user;
    }

    @Override
    public void updateById(User user) {
        userMapper.updateById(user);
    }
}
