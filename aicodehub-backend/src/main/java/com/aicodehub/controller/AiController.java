package com.aicodehub.controller;

import com.aicodehub.common.Result;
import com.aicodehub.service.DeepSeekService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

/**
 * AI 分析接口
 * 提供代码解释、优化建议、测试生成等功能
 * 支持普通JSON返回和SSE流式返回
 */
@Slf4j
@RestController
@RequestMapping("/api/ai")
@RequiredArgsConstructor
public class AiController {

    private final DeepSeekService deepSeekService;

    // ===== 普通接口（一次性返回）=====

    @PostMapping("/explain")
    public Result<String> explain(@RequestBody Map<String, String> body) {
        String code = body.get("code");
        String language = body.getOrDefault("language", "Java");
        if (code == null || code.isBlank()) {
            return Result.error(400, "代码内容不能为空");
        }
        String result = deepSeekService.explainCode(code, language);
        return Result.success(result);
    }

    @PostMapping("/optimize")
    public Result<String> optimize(@RequestBody Map<String, String> body) {
        String code = body.get("code");
        String language = body.getOrDefault("language", "Java");
        if (code == null || code.isBlank()) {
            return Result.error(400, "代码内容不能为空");
        }
        String result = deepSeekService.optimizeCode(code, language);
        return Result.success(result);
    }

    @PostMapping("/test")
    public Result<String> generateTest(@RequestBody Map<String, String> body) {
        String code = body.get("code");
        String language = body.getOrDefault("language", "Java");
        if (code == null || code.isBlank()) {
            return Result.error(400, "代码内容不能为空");
        }
        String result = deepSeekService.generateTests(code, language);
        return Result.success(result);
    }

    @PostMapping("/translate")
    public Result<String> translate(@RequestBody Map<String, String> body) {
        String code = body.get("code");
        String fromLang = body.getOrDefault("fromLang", "Java");
        String toLang = body.get("toLang");
        if (code == null || code.isBlank()) {
            return Result.error(400, "代码内容不能为空");
        }
        if (toLang == null || toLang.isBlank()) {
            return Result.error(400, "目标语言不能为空");
        }
        String result = deepSeekService.translateCode(code, fromLang, toLang);
        return Result.success(result);
    }

    @PostMapping("/doc")
    public Result<String> generateDoc(@RequestBody Map<String, String> body) {
        String code = body.get("code");
        String language = body.getOrDefault("language", "Java");
        if (code == null || code.isBlank()) {
            return Result.error(400, "代码内容不能为空");
        }
        String result = deepSeekService.generateDocs(code, language);
        return Result.success(result);
    }

    @PostMapping("/review")
    public Result<String> review(@RequestBody Map<String, String> body) {
        String code = body.get("code");
        String language = body.getOrDefault("language", "Java");
        if (code == null || code.isBlank()) {
            return Result.error(400, "代码内容不能为空");
        }
        String result = deepSeekService.reviewCode(code, language);
        return Result.success(result);
    }

    // ===== 流式接口（SSE，逐字返回）=====

    @PostMapping(value = "/explain/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter explainStream(@RequestBody Map<String, String> body) {
        return handleStream(body, "explain");
    }

    @PostMapping(value = "/optimize/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter optimizeStream(@RequestBody Map<String, String> body) {
        return handleStream(body, "optimize");
    }

    @PostMapping(value = "/test/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter testStream(@RequestBody Map<String, String> body) {
        return handleStream(body, "test");
    }

    @PostMapping(value = "/translate/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter translateStream(@RequestBody Map<String, String> body) {
        return handleStream(body, "translate");
    }

    @PostMapping(value = "/doc/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter docStream(@RequestBody Map<String, String> body) {
        return handleStream(body, "doc");
    }

    @PostMapping(value = "/review/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter reviewStream(@RequestBody Map<String, String> body) {
        return handleStream(body, "review");
    }

    // ===== 统一流式处理 =====

    private SseEmitter handleStream(Map<String, String> body, String type) {
        SseEmitter emitter = new SseEmitter(120_000L); // 2分钟超时
        String code = body.get("code");
        String language = body.getOrDefault("language", "Java");

        if (code == null || code.isBlank()) {
            try {
                emitter.send(SseEmitter.event().name("error").data("代码内容不能为空"));
                emitter.complete();
            } catch (IOException e) {
                emitter.completeWithError(e);
            }
            return emitter;
        }

        CompletableFuture.runAsync(() -> {
            try {
                switch (type) {
                    case "explain" -> deepSeekService.explainCodeStream(code, language, chunk -> sendChunk(emitter, chunk));
                    case "optimize" -> deepSeekService.optimizeCodeStream(code, language, chunk -> sendChunk(emitter, chunk));
                    case "test" -> deepSeekService.generateTestsStream(code, language, chunk -> sendChunk(emitter, chunk));
                    case "translate" -> {
                        String toLang = body.get("toLang");
                        if (toLang == null || toLang.isBlank()) {
                            sendChunk(emitter, "错误：目标语言不能为空");
                        } else {
                            deepSeekService.translateCodeStream(code, language, toLang, chunk -> sendChunk(emitter, chunk));
                        }
                    }
                    case "doc" -> deepSeekService.generateDocsStream(code, language, chunk -> sendChunk(emitter, chunk));
                    case "review" -> deepSeekService.reviewCodeStream(code, language, chunk -> sendChunk(emitter, chunk));
                }
                emitter.complete();
            } catch (Exception e) {
                log.error("SSE流式处理异常", e);
                emitter.completeWithError(e);
            }
        });

        return emitter;
    }

    private void sendChunk(SseEmitter emitter, String chunk) {
        try {
            emitter.send(SseEmitter.event().name("message").data(chunk));
        } catch (IOException e) {
            log.warn("SSE发送失败，客户端可能已断开");
        }
    }
}
