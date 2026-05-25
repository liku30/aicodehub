package com.aicodehub;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * AiCodeHub - AI智能代码片段管理平台 启动类
 *
 * @author AiCodeHub
 */
@SpringBootApplication
@MapperScan("com.aicodehub.mapper")
public class AiCodeHubApplication {

    public static void main(String[] args) {
        SpringApplication.run(AiCodeHubApplication.class, args);
        System.out.println("===== AiCodeHub 启动成功 =====");
        System.out.println("===== API文档: http://localhost:8080/doc.html =====");
    }
}
