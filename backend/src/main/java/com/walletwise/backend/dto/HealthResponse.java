package com.walletwise.backend.dto;

public record HealthResponse(
        String status,
        String database
) {
}