package com.walletwise.backend.dto;

import java.math.BigDecimal;

public record CategoryStatisticsResponse(
        String category,
        BigDecimal amount
) {
}