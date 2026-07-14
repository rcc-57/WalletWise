package com.walletwise.backend.controller;

import com.walletwise.backend.dto.HealthResponse;
import com.walletwise.backend.service.HealthService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/health")
public class HealthController {

    private final HealthService healthService;

    public HealthController(HealthService healthService) {
        this.healthService = healthService;
    }

    @GetMapping
    public HealthResponse checkHealth() {
        boolean databaseAvailable = healthService.isDatabaseAvailable();

        return new HealthResponse(
                "UP",
                databaseAvailable ? "UP" : "DOWN"
        );
    }
}