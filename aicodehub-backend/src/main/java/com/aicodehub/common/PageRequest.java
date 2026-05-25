package com.aicodehub.common;

import lombok.Data;

/**
 * 分页请求参数
 * 所有需要分页的接口都可以接收这个参数
 */
@Data
public class PageRequest {

    /** 当前页码，默认第1页 */
    private int pageNum = 1;

    /** 每页条数，默认10条 */
    private int pageSize = 10;

    /** 排序字段 */
    private String orderBy;

    /** 是否升序，默认降序（新的在前） */
    private boolean asc = false;

    /**
     * 计算SQL中的LIMIT偏移量
     * 例如：pageNum=2, pageSize=10 → offset=10
     */
    public int getOffset() {
        return (pageNum - 1) * pageSize;
    }
}
