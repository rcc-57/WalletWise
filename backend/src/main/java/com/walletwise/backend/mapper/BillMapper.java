package com.walletwise.backend.mapper;

import com.walletwise.backend.entity.Bill;
import com.walletwise.backend.entity.BillType;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface BillMapper {

    @Insert("""
            INSERT INTO bills (
                user_id,
                type,
                category,
                amount,
                bill_date,
                remark
            )
            VALUES (
                #{userId},
                #{type},
                #{category},
                #{amount},
                #{billDate},
                #{remark}
            )
            """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Bill bill);

    @Select("""
            SELECT
                id,
                user_id,
                type,
                category,
                amount,
                bill_date,
                remark,
                created_at,
                updated_at
            FROM bills
            WHERE id = #{id}
              AND user_id = #{userId}
            """)
    Bill findByIdAndUserId(
            @Param("id") Long id,
            @Param("userId") Long userId
    );

    @Select("""
            <script>
            SELECT
                id,
                user_id,
                type,
                category,
                amount,
                bill_date,
                remark,
                created_at,
                updated_at
            FROM bills
            WHERE user_id = #{userId}

            <if test="type != null">
                AND type = #{type}
            </if>

            ORDER BY bill_date DESC, id DESC
            </script>
            """)
    List<Bill> findAllByUserId(
            @Param("userId") Long userId,
            @Param("type") BillType type
    );

    @Update("""
            UPDATE bills
            SET
                type = #{type},
                category = #{category},
                amount = #{amount},
                bill_date = #{billDate},
                remark = #{remark}
            WHERE id = #{id}
              AND user_id = #{userId}
            """)
    int update(Bill bill);

    @Delete("""
            DELETE FROM bills
            WHERE id = #{id}
              AND user_id = #{userId}
            """)
    int deleteByIdAndUserId(
            @Param("id") Long id,
            @Param("userId") Long userId
    );
}