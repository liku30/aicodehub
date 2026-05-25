package com.aicodehub.controller;

import com.aicodehub.common.Result;
import com.aicodehub.entity.Tag;
import com.aicodehub.service.TagService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 标签控制器
 */
@RestController
@RequestMapping("/api/tag")
@RequiredArgsConstructor
public class TagController {

    private final TagService tagService;

    /** 获取所有标签 */
    @GetMapping("/list")
    public Result<List<Tag>> list() {
        return Result.success(tagService.listAll());
    }

    /** 获取热门标签（使用最多的前20个） */
    @GetMapping("/hot")
    public Result<List<Tag>> hot() {
        return Result.success(tagService.hotTags());
    }

    /** 创建标签（需要登录） */
    @PostMapping
    public Result<Long> create(@RequestParam String name,
                                @RequestParam(defaultValue = "#409EFF") String color) {
        Long id = tagService.create(name, color);
        return Result.success("创建成功", id);
    }
}
