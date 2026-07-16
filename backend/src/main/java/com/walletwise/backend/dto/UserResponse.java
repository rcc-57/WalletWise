package com.walletwise.backend.dto;

import java.time.LocalDateTime;

public record UserResponse(
        Long id,
        String username,
        String email,
        String currency,
        LocalDateTime createdAt
) {
}