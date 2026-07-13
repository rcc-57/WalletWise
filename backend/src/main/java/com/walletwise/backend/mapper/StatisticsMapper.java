package com.walletwise.backend.mapper;

import com.walletwise.backend.entity.CategoryTotal;
import com.walletwise.backend.entity.MonthlyTotals;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface StatisticsMapper {

    @Select("""
            SELECT
                COALESCE(
                    SUM(
                        CASE
                            WHEN type = 'INCOME'
                            THEN amount
                            ELSE 0
                        END
                    ),
                    0.00
                ) AS total_income,

                COALESCE(
                    SUM(
                        CASE
                            WHEN type = 'EXPENSE'
                            THEN amount
                            ELSE 0
                        END
                    ),
                    0.00
                ) AS total_expense

            FROM bills

            WHERE user_id = #{userId}
              AND bill_date >= #{startDate}
              AND bill_date < #{endDate}
            """)
    MonthlyTotals findMonthlyTotals(
            @Param("userId") Long userId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate
    );

    @Select("""
            SELECT
                category,
                SUM(amount) AS amount

            FROM bills

            WHERE user_id = #{userId}
              AND type = 'EXPENSE'
              AND bill_date >= #{startDate}
              AND bill_date < #{endDate}

            GROUP BY category
            ORDER BY amount DESC
            """)
    List<CategoryTotal> findExpenseCategories(
            @Param("userId") Long userId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate
    );
}