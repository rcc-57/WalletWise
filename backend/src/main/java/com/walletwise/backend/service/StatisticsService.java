package com.walletwise.backend.service;

import com.walletwise.backend.dto.CategoryStatisticsResponse;
import com.walletwise.backend.dto.MonthlyStatisticsResponse;
import com.walletwise.backend.entity.CategoryTotal;
import com.walletwise.backend.entity.MonthlyTotals;
import com.walletwise.backend.entity.User;
import com.walletwise.backend.mapper.StatisticsMapper;
import com.walletwise.backend.mapper.UserMapper;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

@Service
public class StatisticsService {

    private final StatisticsMapper statisticsMapper;
    private final UserMapper userMapper;

    public StatisticsService(
            StatisticsMapper statisticsMapper,
            UserMapper userMapper
    ) {
        this.statisticsMapper = statisticsMapper;
        this.userMapper = userMapper;
    }

    public MonthlyStatisticsResponse getMonthlyStatistics(
            String username,
            Integer year,
            Integer month
    ) {
        User user = getRequiredUser(username);
        YearMonth selectedMonth = resolveMonth(year, month);

        LocalDate startDate = selectedMonth.atDay(1);
        LocalDate endDate = selectedMonth
                .plusMonths(1)
                .atDay(1);

        MonthlyTotals totals =
                statisticsMapper.findMonthlyTotals(
                        user.getId(),
                        startDate,
                        endDate
                );

        List<CategoryStatisticsResponse> categories =
                statisticsMapper.findExpenseCategories(
                                user.getId(),
                                startDate,
                                endDate
                        )
                        .stream()
                        .map(this::toCategoryResponse)
                        .toList();

        BigDecimal totalIncome =
                normalizeMoney(totals.getTotalIncome());

        BigDecimal totalExpense =
                normalizeMoney(totals.getTotalExpense());

        BigDecimal balance =
                totalIncome.subtract(totalExpense);

        return new MonthlyStatisticsResponse(
                selectedMonth.toString(),
                totalIncome,
                totalExpense,
                balance,
                categories
        );
    }

    private YearMonth resolveMonth(
            Integer year,
            Integer month
    ) {
        if (year == null && month == null) {
            return YearMonth.now();
        }

        if (year == null || month == null) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Year and month must be provided together"
            );
        }

        if (year < 2000 || year > 2100) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Year must be between 2000 and 2100"
            );
        }

        if (month < 1 || month > 12) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Month must be between 1 and 12"
            );
        }

        return YearMonth.of(year, month);
    }

    private BigDecimal normalizeMoney(BigDecimal amount) {
        if (amount == null) {
            return BigDecimal.ZERO.setScale(2);
        }

        return amount.setScale(2, RoundingMode.HALF_UP);
    }

    private CategoryStatisticsResponse toCategoryResponse(
            CategoryTotal category
    ) {
        return new CategoryStatisticsResponse(
                category.getCategory(),
                normalizeMoney(category.getAmount())
        );
    }

    private User getRequiredUser(String username) {
        User user = userMapper.findByUsername(username);

        if (user == null) {
            throw new ResponseStatusException(
                    HttpStatus.UNAUTHORIZED,
                    "Authenticated user no longer exists"
            );
        }

        return user;
    }
}