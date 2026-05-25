package com.aicodehub.security;

import cn.hutool.core.util.StrUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * JWT认证过滤器
 *
 * 这个过滤器拦截每个请求，做以下事情：
 * 1. 从请求头中取出 Token（Authorization: Bearer xxx）
 * 2. 验证 Token 是否有效
 * 3. 有效 → 把用户信息放入 Spring Security 上下文（标记为已登录）
 * 4. 无效 → 不做处理（未登录状态，由Security决定是否放行）
 *
 * 继承 OncePerRequestFilter 确保每个请求只执行一次
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final UserDetailsServiceImpl userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                     HttpServletResponse response,
                                     FilterChain filterChain) throws ServletException, IOException {

        // 1. 从请求头获取Token
        String token = getTokenFromRequest(request);

        // 2. Token存在且有效 → 设置认证信息
        if (StrUtil.isNotBlank(token) && jwtUtil.validateToken(token)) {
            String username = jwtUtil.getUsernameFromToken(token);

            // 加载用户详情
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);

            // 创建认证对象，放入Security上下文
            UsernamePasswordAuthenticationToken authentication =
                    new UsernamePasswordAuthenticationToken(
                            userDetails, null, userDetails.getAuthorities());
            authentication.setDetails(
                    new WebAuthenticationDetailsSource().buildDetails(request));

            SecurityContextHolder.getContext().setAuthentication(authentication);

            log.debug("用户 {} 认证成功", username);
        }

        // 3. 继续后续过滤器
        filterChain.doFilter(request, response);
    }

    /**
     * 从请求头中提取Token
     * 格式：Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
     */
    private String getTokenFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (StrUtil.isNotBlank(bearerToken) && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);  // 去掉"Bearer "前缀
        }
        return null;
    }
}
