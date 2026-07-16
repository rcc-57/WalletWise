package com.walletwise.backend.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record UpdateProfileRequest(

        @Email(message = "Email must be valid")
        @Size(
                max = 255,
                message = "Email must not exceed 255 characters"
        )
        String email,

        @NotBlank(message = "Currency is required")
        @Pattern(
                regexp = "USD|EUR|GBP|CNY|RUB",
                message = "Unsupported currency"
        )
        String currency
) {
}