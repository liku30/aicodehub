package com.aicodehub.service;

import com.aicodehub.config.AiProperties;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.function.Consumer;

/**
 * DeepSeek AI 服务
 * 封装所有与 DeepSeek API 的交互逻辑
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class DeepSeekService {

    private final AiProperties aiProperties;
    private final ObjectMapper objectMapper = new ObjectMapper();

    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .build();

    // ===== 各种 AI 功能的 System Prompt =====

    private static final String EXPLAIN_PROMPT = "你是一个资深编程导师。请用中文详细解释以下代码的功能、逻辑和关键点。用通俗易懂的语言，适合初中级开发者理解。分点说明：1.整体功能 2.关键逻辑 3.时间/空间复杂度（如适用）";

    private static final String OPTIMIZE_PROMPT = "你是一个性能优化专家。请分析以下代码，给出优化建议。包括：1.时间复杂度分析 2.空间复杂度分析 3.具体的优化方案（给出优化后的代码）4.优化理由";

    private static final String TEST_PROMPT = "你是一个测试专家。请为以下代码生成完整的单元测试用例。要求：1.覆盖正常场景 2.覆盖边界条件 3.覆盖异常场景 4.使用对应语言的主流测试框架。直接给出可运行的测试代码。";

    private static final String TRANSLATE_PROMPT_TEMPLATE = "你是一个多语言编程专家。请将以下代码翻译成 %s。要求：1.保持逻辑完全一致 2.使用目标语言的惯用写法和标准库 3.保留注释。直接给出代码，不需要额外解释。";

    private static final String DOC_PROMPT = "你是一个技术文档专家。请为以下代码生成详细的文档注释。包括：1.功能描述 2.参数说明 3.返回值说明 4.使用示例 5.注意事项。使用对应语言的标准文档格式（如Java用Javadoc，Python用docstring）。";

    private static final String REVIEW_PROMPT = "你是一个高级代码审查专家。请审查以下代码，从以下维度给出反馈：1.潜在Bug 2.安全风险 3.代码规范 4.性能问题 5.可维护性。用严重等级（Critical/Warning/Info）标注每个问题，并给出修复建议。";

    // ===== 核心方法：普通调用 =====

    /**
     * 调用 DeepSeek API（非流式）
     */
    public String chat(String systemPrompt, String userMessage) {
        try {
            String requestBody = buildRequestBody(systemPrompt, userMessage, false);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(aiProperties.getBaseUrl() + "/chat/completions"))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + aiProperties.getApiKey())
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .timeout(Duration.ofSeconds(60))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                log.error("DeepSeek API 调用失败: {} - {}", response.statusCode(), response.body());
                return "AI 服务暂时不可用，请稍后再试。";
            }

            JsonNode json = objectMapper.readTree(response.body());
            return json.get("choices").get(0).get("message").get("content").asText();

        } catch (Exception e) {
            log.error("调用 DeepSeek API 异常", e);
            return "AI 服务异常，请稍后再试。";
        }
    }

    /**
     * 调用 DeepSeek API（流式 SSE）
     * 通过 Consumer 回调逐块返回内容
     */
    public void chatStream(String systemPrompt, String userMessage, Consumer<String> onChunk) {
        try {
            String requestBody = buildRequestBody(systemPrompt, userMessage, true);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(aiProperties.getBaseUrl() + "/chat/completions"))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + aiProperties.getApiKey())
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .timeout(Duration.ofSeconds(120))
                    .build();

            httpClient.sendAsync(request, HttpResponse.BodyHandlers.ofLines())
                    .thenAccept(response -> {
                        if (response.statusCode() != 200) {
                            onChunk.accept("AI 服务暂时不可用（HTTP " + response.statusCode() + "）");
                            return;
                        }
                        response.body().forEach(line -> {
                            if (line.startsWith("data: ")) {
                                String data = line.substring(6).trim();
                                if ("[DONE]".equals(data)) return;
                                try {
                                    JsonNode json = objectMapper.readTree(data);
                                    String content = json.get("choices").get(0).get("delta").get("content").asText();
                                    onChunk.accept(content);
                                } catch (Exception ignored) {
                                    // 跳过解析失败的行
                                }
                            }
                        });
                    })
                    .exceptionally(e -> {
                        log.error("流式调用 DeepSeek API 异常", e);
                        onChunk.accept("AI 服务异常，请稍后再试。");
                        return null;
                    });

        } catch (Exception e) {
            log.error("构建流式请求异常", e);
            onChunk.accept("AI 服务异常，请稍后再试。");
        }
    }

    // ===== 各 AI 功能的便捷方法 =====

    public String explainCode(String code, String language) {
        return chat(EXPLAIN_PROMPT, "以下是" + language + "代码：\n\n```" + language.toLowerCase() + "\n" + code + "\n```");
    }

    public void explainCodeStream(String code, String language, Consumer<String> onChunk) {
        chatStream(EXPLAIN_PROMPT, "以下是" + language + "代码：\n\n```" + language.toLowerCase() + "\n" + code + "\n```", onChunk);
    }

    public String optimizeCode(String code, String language) {
        return chat(OPTIMIZE_PROMPT, "以下是" + language + "代码：\n\n```" + language.toLowerCase() + "\n" + code + "\n```");
    }

    public void optimizeCodeStream(String code, String language, Consumer<String> onChunk) {
        chatStream(OPTIMIZE_PROMPT, "以下是" + language + "代码：\n\n```" + language.toLowerCase() + "\n" + code + "\n```", onChunk);
    }

    public String generateTests(String code, String language) {
        return chat(TEST_PROMPT, "以下是" + language + "代码：\n\n```" + language.toLowerCase() + "\n" + code + "\n```");
    }

    public void generateTestsStream(String code, String language, Consumer<String> onChunk) {
        chatStream(TEST_PROMPT, "以下是" + language + "代码：\n\n```" + language.toLowerCase() + "\n" + code + "\n```", onChunk);
    }

    public String translateCode(String code, String fromLang, String toLang) {
        String prompt = String.format(TRANSLATE_PROMPT_TEMPLATE, toLang);
        return chat(prompt, "以下是" + fromLang + "代码：\n\n```" + fromLang.toLowerCase() + "\n" + code + "\n```");
    }

    public void translateCodeStream(String code, String fromLang, String toLang, Consumer<String> onChunk) {
        String prompt = String.format(TRANSLATE_PROMPT_TEMPLATE, toLang);
        chatStream(prompt, "以下是" + fromLang + "代码：\n\n```" + fromLang.toLowerCase() + "\n" + code + "\n```", onChunk);
    }

    public String generateDocs(String code, String language) {
        return chat(DOC_PROMPT, "以下是" + language + "代码：\n\n```" + language.toLowerCase() + "\n" + code + "\n```");
    }

    public void generateDocsStream(String code, String language, Consumer<String> onChunk) {
        chatStream(DOC_PROMPT, "以下是" + language + "代码：\n\n```" + language.toLowerCase() + "\n" + code + "\n```", onChunk);
    }

    public String reviewCode(String code, String language) {
        return chat(REVIEW_PROMPT, "以下是" + language + "代码：\n\n```" + language.toLowerCase() + "\n" + code + "\n```");
    }

    public void reviewCodeStream(String code, String language, Consumer<String> onChunk) {
        chatStream(REVIEW_PROMPT, "以下是" + language + "代码：\n\n```" + language.toLowerCase() + "\n" + code + "\n```", onChunk);
    }

    // ===== 内部方法 =====

    private String buildRequestBody(String systemPrompt, String userMessage, boolean stream) {
        ObjectNode root = objectMapper.createObjectNode();
        root.put("model", aiProperties.getModel());
        root.put("stream", stream);
        root.put("temperature", 0.7);
        root.put("max_tokens", 2048);

        ArrayNode messages = objectMapper.createArrayNode();

        ObjectNode sysMsg = objectMapper.createObjectNode();
        sysMsg.put("role", "system");
        sysMsg.put("content", systemPrompt);
        messages.add(sysMsg);

        ObjectNode userMsg = objectMapper.createObjectNode();
        userMsg.put("role", "user");
        userMsg.put("content", userMessage);
        messages.add(userMsg);

        root.set("messages", messages);
        return root.toString();
    }
}
