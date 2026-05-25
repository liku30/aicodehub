package com.aicodehub.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.List;

/**
 * 跨域配置
 *
 * 前端(localhost:5173)访问后端(localhost:8080)属于跨域请求
 * 浏览器的同源策略会阻止这种请求，需要后端明确允许
 */
@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();

        // 允许的前端地址（开发时是localhost:5173，部署后换成你的域名）
        config.setAllowedOriginPatterns(List.of("*"));

        // 允许携带Cookie（JWT放在Cookie中时需要）
        config.setAllowCredentials(true);

        // 允许的请求头
        config.setAllowedHeaders(List.of("*"));

        // 允许的HTTP方法
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));

        // 预检请求的缓存时间（1小时内不需要再发预检请求）
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);

        return new CorsFilter(source);
    }
}
