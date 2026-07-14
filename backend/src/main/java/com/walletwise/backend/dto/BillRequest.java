package com.walletwise.backend.dto;

import com.walletwise.backend.entity.BillType;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.time.LocalDate;

public record BillRequest(

        @NotNull(message = "Bill type is required")
        BillType type,

        @NotBlank(message = "Category is required")
        @Size(max = 30, message = "Category must not exceed 30 characters")
        String category,

        @NotNull(message = "Amount is required")
        @DecimalMin(
                value = "0.01",
                message = "Amount must be greater than zero"
        )
        @Digits(
                integer = 10,
                fraction = 2,
                message = "Amount must contain no more than two decimal places"
        )
        BigDecimal amount,

        @NotNull(message = "Bill date is required")
        LocalDate billDate,

        @Size(max = 255, message = "Remark must not exceed 255 characters")
        String remark
) {
}