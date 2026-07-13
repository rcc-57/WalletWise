package com.walletwise.backend.service;

import com.walletwise.backend.mapper.HealthMapper;
import org.springframework.stereotype.Service;

@Service
public class HealthService {

    private final HealthMapper healthMapper;

    public HealthService(HealthMapper healthMapper) {
        this.healthMapper = healthMapper;
    }

    public boolean isDatabaseAvailable() {
        Integer result = healthMapper.checkDatabase();
        return result != null && result == 1;
    }
}