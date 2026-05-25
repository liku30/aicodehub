package com.aicodehub.service.impl;

import com.aicodehub.common.BusinessException;
import com.aicodehub.entity.Tag;
import com.aicodehub.mapper.TagMapper;
import com.aicodehub.service.TagService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TagServiceImpl implements TagService {

    private final TagMapper tagMapper;

    @Override
    public List<Tag> listAll() {
        return tagMapper.selectList(
                new LambdaQueryWrapper<Tag>()
                        .orderByDesc(Tag::getSnippetCount));
    }

    @Override
    public List<Tag> hotTags() {
        return tagMapper.selectList(
                new LambdaQueryWrapper<Tag>()
                        .orderByDesc(Tag::getSnippetCount)
                        .last("LIMIT 20"));
    }

    @Override
    public Long create(String name, String color) {
        // 检查是否已存在
        Tag existing = tagMapper.selectOne(
                new LambdaQueryWrapper<Tag>().eq(Tag::getName, name));
        if (existing != null) {
            throw new BusinessException("标签已存在");
        }

        Tag tag = new Tag();
        tag.setName(name);
        tag.setColor(color);
        tag.setSnippetCount(0);
        tagMapper.insert(tag);
        return tag.getId();
    }
}
