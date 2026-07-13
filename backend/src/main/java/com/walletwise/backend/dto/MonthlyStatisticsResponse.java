package com.walletwise.backend.dto;

import java.math.BigDecimal;
import java.util.List;

public record MonthlyStatisticsResponse(
        String month,
        BigDecimal totalIncome,
        BigDecimal totalExpense,
        BigDecimal balance,
        List<CategoryStatisticsResponse> expenseCategories
) {
}