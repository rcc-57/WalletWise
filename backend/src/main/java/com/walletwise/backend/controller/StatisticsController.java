package com.walletwise.backend.controller;

import com.walletwise.backend.dto.MonthlyStatisticsResponse;
import com.walletwise.backend.service.StatisticsService;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/statistics")
public class StatisticsController {

    private final StatisticsService statisticsService;

    public StatisticsController(
            StatisticsService statisticsService
    ) {
        this.statisticsService = statisticsService;
    }

    @GetMapping("/monthly")
    public MonthlyStatisticsResponse getMonthlyStatistics(
            Authentication authentication,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month
    ) {
        return statisticsService.getMonthlyStatistics(
                authentication.getName(),
                year,
                month
        );
    }
}