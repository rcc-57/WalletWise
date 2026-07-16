CREATE DATABASE IF NOT EXISTS online_bookkeeping
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE online_bookkeeping;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(255) NULL UNIQUE,
    currency VARCHAR(3) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bills (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    type VARCHAR(10) NOT NULL,
    category VARCHAR(30) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    bill_date DATE NOT NULL,
    remark VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_bills_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_bill_type
        CHECK (type IN ('INCOME', 'EXPENSE')),

    CONSTRAINT chk_bill_amount
        CHECK (amount > 0),

    INDEX idx_bills_user_date (user_id, bill_date),
    INDEX idx_bills_user_type (user_id, type)
);