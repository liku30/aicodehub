package com.aicodehub.dto.response;

import lombok.Builder;
import lombok.Data;

/**
 * 登录成功后返回的数据
 */
@Data
@Builder
public class LoginResponse {

    /** JWT令牌 */
    private String token;

    /** 用户ID */
    private Long userId;

    /** 用户名 */
    private String username;

    /** 昵称 */
    private String nickname;

    /** 头像 */
    private String avatar;

    /** 角色 */
    private Integer role;
}
