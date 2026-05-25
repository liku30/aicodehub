package com.aicodehub.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

/**
 * JWT工具类
 *
 * 负责：生成Token、解析Token、验证Token
 *
 * JWT的工作原理：
 * 1. 用户登录成功 → 服务器生成一个JWT（包含用户ID和用户名） → 返回给前端
 * 2. 前端每次请求 → 把JWT放在请求头 Authorization: Bearer <token>
 * 3. 服务器收到请求 → 解析JWT → 获取当前用户信息
 *
 * 好处：服务器不需要存储session，无状态，适合分布式部署
 */
@Component
public class JwtUtil {

    /** 密钥（从配置文件读取，至少256位） */
    @Value("${jwt.secret}")
    private String secret;

    /** 过期时间（毫秒），默认7天 */
    @Value("${jwt.expiration}")
    private long expiration;

    /**
     * 生成JWT Token
     *
     * @param userId 用户ID
     * @param username 用户名
     * @return JWT字符串
     */
    public String generateToken(Long userId, String username) {
        return Jwts.builder()
                .subject(username)                    // 主题：用户名
                .claim("userId", userId)              // 自定义声明：用户ID
                .issuedAt(new Date())                 // 签发时间
                .expiration(new Date(System.currentTimeMillis() + expiration))  // 过期时间
                .signWith(getSecretKey())             // 用密钥签名
                .compact();
    }

    /**
     * 从Token中解析出用户名
     */
    public String getUsernameFromToken(String token) {
        return parseToken(token).getSubject();
    }

    /**
     * 从Token中解析出用户ID
     */
    public Long getUserIdFromToken(String token) {
        return parseToken(token).get("userId", Long.class);
    }

    /**
     * 验证Token是否有效（未过期且签名正确）
     */
    public boolean validateToken(String token) {
        try {
            parseToken(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * 解析Token → Claims（声明）
     * 内部方法，供上面的方法调用
     */
    private Claims parseToken(String token) {
        return Jwts.parser()
                .verifyWith(getSecretKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /**
     * 根据密钥字符串生成SecretKey对象
     */
    private SecretKey getSecretKey() {
        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        return Keys.hmacShaKeyFor(keyBytes);
    }
}
