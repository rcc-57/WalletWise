package com.walletwise.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record RegisterRequest(

        @NotBlank(message = "Username is required")
        @Size(
                min = 3,
                max = 50,
                message = "Username must contain 3-50 characters"
        )
        String username,

        @NotBlank(message = "Password is required")
        @Size(
                min = 6,
                max = 72,
                message = "Password must contain 6-72 characters"
        )
        String password,

        @NotBlank(message = "Currency is required")
        @Pattern(
                regexp = "USD|EUR|GBP|CNY|RUB",
                message = "Unsupported currency"
        )
        String currency
) {
}