package com.walletwise.backend.controller;

import com.walletwise.backend.dto.BillRequest;
import com.walletwise.backend.dto.BillResponse;
import com.walletwise.backend.entity.BillType;
import com.walletwise.backend.service.BillService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/bills")
public class BillController {

    private final BillService billService;

    public BillController(BillService billService) {
        this.billService = billService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public BillResponse create(
            Authentication authentication,
            @Valid @RequestBody BillRequest request
    ) {
        return billService.create(
                authentication.getName(),
                request
        );
    }

    @GetMapping
    public List<BillResponse> findAll(
            Authentication authentication,
            @RequestParam(required = false) BillType type
    ) {
        return billService.findAll(
                authentication.getName(),
                type
        );
    }

    @GetMapping("/{id}")
    public BillResponse findById(
            Authentication authentication,
            @PathVariable Long id
    ) {
        return billService.findById(
                authentication.getName(),
                id
        );
    }

    @PutMapping("/{id}")
    public BillResponse update(
            Authentication authentication,
            @PathVariable Long id,
            @Valid @RequestBody BillRequest request
    ) {
        return billService.update(
                authentication.getName(),
                id,
                request
        );
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(
            Authentication authentication,
            @PathVariable Long id
    ) {
        billService.delete(
                authentication.getName(),
                id
        );
    }
}