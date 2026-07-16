USE online_bookkeeping;

ALTER TABLE users
    ADD COLUMN email VARCHAR(255) NULL
        AFTER password,
    ADD COLUMN currency VARCHAR(3) NULL
        AFTER email;

CREATE UNIQUE INDEX uk_users_email
    ON users (email);