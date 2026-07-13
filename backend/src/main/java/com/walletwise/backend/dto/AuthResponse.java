package com.walletwise.backend.dto;

public record AuthResponse(
        String token,
        String tokenType,
        UserResponse user
) {
}