package com.aicodehub.common;

import lombok.Getter;

/**
 * 业务异常类
 *
 * 当业务逻辑出错时（比如用户名已存在、片段不存在等），
 * 直接抛出这个异常，全局异常处理器会捕获并返回统一格式。
 *
 * 使用示例：
 *   throw new BusinessException("用户名已存在");
 *   throw new BusinessException(40001, "用户名已存在");
 */
@Getter
public class BusinessException extends RuntimeException {

    private final int code;

    public BusinessException(String message) {
        this(500, message);
    }

    public BusinessException(int code, String message) {
        super(message);
        this.code = code;
    }
}
