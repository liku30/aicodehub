# ============================================
# AiCodeHub 后端 Dockerfile
# ============================================

# 第一阶段：构建
FROM maven:3.9-eclipse-temurin-17-alpine AS builder
WORKDIR /app

# 先复制pom.xml下载依赖（利用Docker缓存层）
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 复制源代码并打包
COPY src ./src
RUN mvn package -DskipTests -B

# 第二阶段：运行
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# 从构建阶段复制jar包
COPY --from=builder /app/target/*.jar app.jar

# 暴露端口
EXPOSE 8080

# 启动命令
ENTRYPOINT ["java", "-jar", "app.jar"]
