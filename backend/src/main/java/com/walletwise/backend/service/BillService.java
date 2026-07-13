package com.walletwise.backend.service;

import com.walletwise.backend.dto.BillRequest;
import com.walletwise.backend.dto.BillResponse;
import com.walletwise.backend.entity.Bill;
import com.walletwise.backend.entity.BillType;
import com.walletwise.backend.entity.User;
import com.walletwise.backend.mapper.BillMapper;
import com.walletwise.backend.mapper.UserMapper;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Locale;
import java.util.Set;

@Service
public class BillService {

    private static final Set<String> INCOME_CATEGORIES = Set.of(
            "SALARY",
            "BONUS",
            "INVESTMENT",
            "OTHER"
    );

    private static final Set<String> EXPENSE_CATEGORIES = Set.of(
            "FOOD",
            "TRANSPORT",
            "SHOPPING",
            "HOUSING",
            "HEALTH",
            "EDUCATION",
            "ENTERTAINMENT",
            "OTHER"
    );

    private final BillMapper billMapper;
    private final UserMapper userMapper;

    public BillService(
            BillMapper billMapper,
            UserMapper userMapper
    ) {
        this.billMapper = billMapper;
        this.userMapper = userMapper;
    }

    public BillResponse create(
            String username,
            BillRequest request
    ) {
        User user = getRequiredUser(username);

        Bill bill = new Bill();
        bill.setUserId(user.getId());
        applyRequest(bill, request);

        billMapper.insert(bill);

        Bill savedBill = getRequiredBill(
                bill.getId(),
                user.getId()
        );

        return toResponse(savedBill);
    }

    public List<BillResponse> findAll(
            String username,
            BillType type
    ) {
        User user = getRequiredUser(username);

        return billMapper
                .findAllByUserId(user.getId(), type)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    public BillResponse findById(
            String username,
            Long id
    ) {
        User user = getRequiredUser(username);
        Bill bill = getRequiredBill(id, user.getId());

        return toResponse(bill);
    }

    public BillResponse update(
            String username,
            Long id,
            BillRequest request
    ) {
        User user = getRequiredUser(username);
        Bill bill = getRequiredBill(id, user.getId());

        applyRequest(bill, request);
        billMapper.update(bill);

        Bill updatedBill = getRequiredBill(id, user.getId());
        return toResponse(updatedBill);
    }

    public void delete(
            String username,
            Long id
    ) {
        User user = getRequiredUser(username);

        getRequiredBill(id, user.getId());

        billMapper.deleteByIdAndUserId(
                id,
                user.getId()
        );
    }

    private void applyRequest(
            Bill bill,
            BillRequest request
    ) {
        String category = normalizeCategory(
                request.type(),
                request.category()
        );

        bill.setType(request.type());
        bill.setCategory(category);
        bill.setAmount(request.amount());
        bill.setBillDate(request.billDate());
        bill.setRemark(normalizeRemark(request.remark()));
    }

    private String normalizeCategory(
            BillType type,
            String category
    ) {
        String normalizedCategory = category
                .trim()
                .toUpperCase(Locale.ROOT);

        Set<String> allowedCategories =
                type == BillType.INCOME
                        ? INCOME_CATEGORIES
                        : EXPENSE_CATEGORIES;

        if (!allowedCategories.contains(normalizedCategory)) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Invalid category for " + type
            );
        }

        return normalizedCategory;
    }

    private String normalizeRemark(String remark) {
        if (remark == null || remark.isBlank()) {
            return null;
        }

        return remark.trim();
    }

    private User getRequiredUser(String username) {
        User user = userMapper.findByUsername(username);

        if (user == null) {
            throw new ResponseStatusException(
                    HttpStatus.UNAUTHORIZED,
                    "Authenticated user no longer exists"
            );
        }

        return user;
    }

    private Bill getRequiredBill(
            Long id,
            Long userId
    ) {
        Bill bill = billMapper.findByIdAndUserId(id, userId);

        if (bill == null) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    "Bill not found"
            );
        }

        return bill;
    }

    private BillResponse toResponse(Bill bill) {
        return new BillResponse(
                bill.getId(),
                bill.getType(),
                bill.getCategory(),
                bill.getAmount(),
                bill.getBillDate(),
                bill.getRemark(),
                bill.getCreatedAt(),
                bill.getUpdatedAt()
        );
    }
}