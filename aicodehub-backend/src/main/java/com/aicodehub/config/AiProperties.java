package com.aicodehub.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * DeepSeek AI 配置属性
 */
@Data
@Component
@ConfigurationProperties(prefix = "ai.deepseek")
public class AiProperties {
    private String apiKey;
    private String baseUrl = "https://api.deepseek.com";
    private String model = "deepseek-chat";
}
