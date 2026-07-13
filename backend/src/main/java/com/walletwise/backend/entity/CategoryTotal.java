package com.walletwise.backend.entity;

import java.math.BigDecimal;

public class CategoryTotal {

    private String category;
    private BigDecimal amount;

    public CategoryTotal() {
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
}