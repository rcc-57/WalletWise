USE online_bookkeeping;

-- Demo account:
-- Username: demo_walletwise
-- Password: Demo123!
-- Currency: USD

INSERT IGNORE INTO users (
    username,
    password,
    email,
    currency
)
VALUES (
    'demo_walletwise',
    '$2b$10$OwC9S8cZos03CcNQLze6uuZ8B9E966KPvCcwSFMKoerfX0cFJdkva',
    NULL,
    'USD'
);

-- Restore the expected demo password.
-- Keep an existing email if the user added one.
-- Set USD only if the demo account does not have a currency yet.
UPDATE users
SET
    password = '$2b$10$OwC9S8cZos03CcNQLze6uuZ8B9E966KPvCcwSFMKoerfX0cFJdkva',
    currency = COALESCE(currency, 'USD')
WHERE username = 'demo_walletwise';

SET @demo_user_id = (
    SELECT id
    FROM users
    WHERE username = 'demo_walletwise'
);

-- Only demo bills are recreated.
-- Other users are not affected.
DELETE FROM bills
WHERE user_id = @demo_user_id;

INSERT INTO bills (
    user_id,
    type,
    category,
    amount,
    bill_date,
    remark
)
VALUES
(
    @demo_user_id,
    'INCOME',
    'SALARY',
    5000.00,
    '2026-07-01',
    'Monthly salary'
),
(
    @demo_user_id,
    'INCOME',
    'BONUS',
    500.00,
    '2026-07-05',
    'Project bonus'
),
(
    @demo_user_id,
    'EXPENSE',
    'FOOD',
    620.50,
    '2026-07-06',
    'Groceries and restaurants'
),
(
    @demo_user_id,
    'EXPENSE',
    'TRANSPORT',
    180.00,
    '2026-07-08',
    'Public transport'
),
(
    @demo_user_id,
    'EXPENSE',
    'HOUSING',
    1500.00,
    '2026-07-02',
    'Monthly rent'
),
(
    @demo_user_id,
    'EXPENSE',
    'ENTERTAINMENT',
    250.00,
    '2026-07-10',
    'Cinema and entertainment'
);
