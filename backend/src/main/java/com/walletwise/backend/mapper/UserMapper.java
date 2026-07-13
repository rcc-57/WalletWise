package com.walletwise.backend.mapper;

import com.walletwise.backend.entity.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UserMapper {

    @Select("""
            SELECT id, username, password, created_at
            FROM users
            WHERE username = #{username}
            """)
    User findByUsername(@Param("username") String username);

    @Select("""
            SELECT id, username, password, created_at
            FROM users
            WHERE id = #{id}
            """)
    User findById(@Param("id") Long id);

    @Insert("""
            INSERT INTO users (username, password)
            VALUES (#{username}, #{password})
            """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(User user);
}