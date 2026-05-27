package com.aicodehub.config;

import com.aicodehub.security.JwtAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.RegexRequestMatcher;

/**
 * Spring Security 配置类
 *
 * 核心配置：
 * 1. 哪些接口需要登录，哪些不需要
 * 2. 关闭Session（我们用JWT，不需要Session）
 * 3. 把JWT过滤器加入Security过滤器链
 * 4. 跨域配置
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity  // 启用方法级别的权限控制（如 @PreAuthorize）
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    /**
     * 安全过滤器链配置
     * 这是Spring Security最核心的配置
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // 1. 关闭CSRF（前后端分离不需要，用JWT替代）
            .csrf(AbstractHttpConfigurer::disable)

            // 2. 跨域配置（不阻止跨域，我们在CorsConfig中单独配置）
            .cors(cors -> {})

            // 3. 不使用Session（无状态，每次请求都验证Token）
            .sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))

            // 4. 配置接口权限规则
            .authorizeHttpRequests(auth -> auth
                // 放行OPTIONS预检请求（CORS需要）
                .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()

                // 放行的接口（不需要登录就能访问）
                .requestMatchers(
                    "/api/auth/**",          // 登录、注册
                    "/api/snippet/explore",  // 探索广场（公开片段）
                    "/api/tag/list",         // 标签列表
                    "/api/tag/hot",          // 热门标签
                    "/doc.html",             // API文档
                    "/webjars/**",           // API文档资源
                    "/v3/api-docs/**"        // OpenAPI文档
                ).permitAll()

                // 允许GET请求访问片段详情（仅数字ID路径，排除/my、/favorites等）
                .requestMatchers(new RegexRequestMatcher("^/api/snippet/\\d+$", "GET")).permitAll()

                // 允许GET请求获取评论
                .requestMatchers(HttpMethod.GET, "/api/comment/**").permitAll()

                // 其他所有接口都需要登录认证
                .anyRequest().authenticated()
            )

            // 5. 把JWT过滤器加到Security过滤器链中（在用户名密码过滤器之前）
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    /**
     * 密码编码器
     * 注册时用BCrypt加密密码，登录时用BCrypt比对
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * 认证管理器
     * 用于登录时手动触发认证流程
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }
}
