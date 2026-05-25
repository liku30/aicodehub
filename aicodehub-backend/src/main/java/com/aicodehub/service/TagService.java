package com.aicodehub.service;

import com.aicodehub.entity.Tag;

import java.util.List;

public interface TagService {
    List<Tag> listAll();
    List<Tag> hotTags();
    Long create(String name, String color);
}
