package com.aicodehub.common;

import lombok.Data;

/**
 * 统一返回格式
 * 所有接口都用这个格式返回，前端处理起来统一
 *
 * 使用示例：
 *   成功：Result.success(data) 或 Result.success("操作成功", data)
 *   失败：Result.error("用户名已存在")
 *   失败：Result.error(40001, "用户名已存在")
 */
@Data
public class Result<T> {

    /** 状态码：200成功，其他为错误 */
    private int code;

    /** 提示信息 */
    private String message;

    /** 返回数据 */
    private T data;

    /** 成功（无数据） */
    public static <T> Result<T> success() {
        return success("success", null);
    }

    /** 成功（有数据） */
    public static <T> Result<T> success(T data) {
        return success("success", data);
    }

    /** 成功（自定义消息+数据） */
    public static <T> Result<T> success(String message, T data) {
        Result<T> result = new Result<>();
        result.setCode(200);
        result.setMessage(message);
        result.setData(data);
        return result;
    }

    /** 失败（默认错误码） */
    public static <T> Result<T> error(String message) {
        return error(500, message);
    }

    /** 失败（自定义错误码） */
    public static <T> Result<T> error(int code, String message) {
        Result<T> result = new Result<>();
        result.setCode(code);
        result.setMessage(message);
        return result;
    }
}
