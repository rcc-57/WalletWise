package com.walletwise.backend.entity;

import java.math.BigDecimal;

public class MonthlyTotals {

    private BigDecimal totalIncome;
    private BigDecimal totalExpense;

    public MonthlyTotals() {
    }

    public BigDecimal getTotalIncome() {
        return totalIncome;
    }

    public void setTotalIncome(BigDecimal totalIncome) {
        this.totalIncome = totalIncome;
    }

    public BigDecimal getTotalExpense() {
        return totalExpense;
    }

    public void setTotalExpense(BigDecimal totalExpense) {
        this.totalExpense = totalExpense;
    }
}