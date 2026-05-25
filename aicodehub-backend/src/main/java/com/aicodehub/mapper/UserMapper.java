package com.aicodehub.mapper;

import com.aicodehub.entity.User;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户Mapper接口
 *
 * 继承 BaseMapper<User> 后，自动拥有这些方法：
 *   insert(User)           → 插入一条记录
 *   deleteById(Long id)    → 根据ID删除
 *   updateById(User)       → 根据ID更新
 *   selectById(Long id)    → 根据ID查询
 *   selectList(Wrapper)    → 条件查询列表
 *   selectPage(Page, Wrapper) → 分页查询
 *
 * 不需要写SQL就能完成基本的CRUD！
 * 复杂查询才需要在XML中写自定义SQL
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {

    // 基本CRUD已继承，这里写自定义的复杂查询
    // 例如：根据用户名或邮箱查询（后面会加在这里）
}
