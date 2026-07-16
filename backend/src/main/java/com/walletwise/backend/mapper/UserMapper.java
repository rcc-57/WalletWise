package com.walletwise.backend.mapper;

import com.walletwise.backend.entity.User;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface UserMapper {

    @Select("""
            SELECT
                id,
                username,
                password,
                email,
                currency,
                created_at
            FROM users
            WHERE username = #{username}
            """)
    User findByUsername(
            @Param("username") String username
    );

    @Select("""
            SELECT
                id,
                username,
                password,
                email,
                currency,
                created_at
            FROM users
            WHERE id = #{id}
            """)
    User findById(
            @Param("id") Long id
    );

    @Select("""
            SELECT
                id,
                username,
                password,
                email,
                currency,
                created_at
            FROM users
            WHERE email = #{email}
            """)
    User findByEmail(
            @Param("email") String email
    );

    @Insert("""
            INSERT INTO users (
                username,
                password,
                email,
                currency
            )
            VALUES (
                #{username},
                #{password},
                #{email},
                #{currency}
            )
            """)
    @Options(
            useGeneratedKeys = true,
            keyProperty = "id"
    )
    int insert(User user);

    @Update("""
            UPDATE users
            SET
                email = #{email},
                currency = #{currency}
            WHERE id = #{id}
            """)
    int updateProfile(User user);
}