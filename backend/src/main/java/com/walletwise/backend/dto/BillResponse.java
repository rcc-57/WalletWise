package com.walletwise.backend.dto;

import com.walletwise.backend.entity.BillType;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public record BillResponse(
        Long id,
        BillType type,
        String category,
        BigDecimal amount,
        LocalDate billDate,
        String remark,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
}