# WalletWise REST API

## Base URL

```text
http://localhost:8080
```

## Content Type

JSON requests must include:

```http
Content-Type: application/json
```

## Authentication

Protected endpoints require a JWT:

```http
Authorization: Bearer <token>
```

The JWT is returned after successful registration or login.

## Error Format

API errors use the following structure:

```json
{
  "timestamp": "2026-07-16T15:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "path": "/api/example"
}
```

# Authentication API

## Register

Creates a new user.

```http
POST /api/auth/register
```

Authentication is not required.

### Request

```json
{
  "username": "ivan",
  "password": "password123",
  "currency": "CNY"
}
```

### Validation

Username:

- Required
- Between 3 and 50 characters
- Must be unique

Password:

- Required
- Between 6 and 72 characters
- Stored as a BCrypt hash

Currency:

- Required
- Must be one of:

```text
USD
EUR
GBP
CNY
RUB
```

Email is not requested during registration and is initially `null`.

### Successful response

Status:

```text
201 Created
```

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "tokenType": "Bearer",
  "user": {
    "id": 1,
    "username": "ivan",
    "email": null,
    "currency": "CNY",
    "createdAt": "2026-07-16T15:30:00"
  }
}
```

### Possible errors

```text
400 Bad Request — invalid request
409 Conflict — username already exists
```

## Login

Authenticates an existing user.

```http
POST /api/auth/login
```

Authentication is not required.

### Request

```json
{
  "username": "ivan",
  "password": "password123"
}
```

### Successful response

Status:

```text
200 OK
```

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "tokenType": "Bearer",
  "user": {
    "id": 1,
    "username": "ivan",
    "email": "ivan@example.com",
    "currency": "CNY",
    "createdAt": "2026-07-16T15:30:00"
  }
}
```

### Possible errors

```text
400 Bad Request — missing username or password
401 Unauthorized — invalid username or password
```

## Get Current User

Returns the authenticated user's profile.

```http
GET /api/auth/me
```

Authentication is required.

### Successful response

```text
200 OK
```

```json
{
  "id": 1,
  "username": "ivan",
  "email": null,
  "currency": "CNY",
  "createdAt": "2026-07-16T15:30:00"
}
```

### Possible errors

```text
401 Unauthorized — token is missing or invalid
404 Not Found — user no longer exists
```

## Update Current User

Updates the authenticated user's email and currency.

```http
PUT /api/auth/me
```

Authentication is required.

Username cannot be changed through this endpoint.

### Request with email

```json
{
  "email": "ivan@example.com",
  "currency": "USD"
}
```

### Request without email

The user can remove their email:

```json
{
  "email": null,
  "currency": "EUR"
}
```

An empty email string is also normalized to `null`.

### Validation

Email:

- Optional
- Must be valid if provided
- Maximum length: 255 characters
- Must be unique

Currency:

- Required
- Must be one of:

```text
USD
EUR
GBP
CNY
RUB
```

### Successful response

```text
200 OK
```

```json
{
  "id": 1,
  "username": "ivan",
  "email": "ivan@example.com",
  "currency": "USD",
  "createdAt": "2026-07-16T15:30:00"
}
```

### Possible errors

```text
400 Bad Request — invalid email or currency
401 Unauthorized — token is missing or invalid
409 Conflict — email is already used
```

# Bill API

All bill endpoints require authentication.

Users can access only their own bills.

## Bill Types

```text
INCOME
EXPENSE
```

## Income Categories

```text
SALARY
BONUS
INVESTMENT
OTHER
```

## Expense Categories

```text
FOOD
TRANSPORT
SHOPPING
HOUSING
HEALTH
EDUCATION
ENTERTAINMENT
OTHER
```

## Create Bill

```http
POST /api/bills
```

### Request

```json
{
  "type": "EXPENSE",
  "category": "FOOD",
  "amount": 35.50,
  "billDate": "2026-07-16",
  "remark": "Lunch"
}
```

### Validation

Type:

- Required
- Must be `INCOME` or `EXPENSE`

Category:

- Required
- Must match the selected bill type
- Maximum length: 30 characters

Amount:

- Required
- Must be greater than zero
- Maximum of 10 integer digits
- Maximum of 2 decimal digits

Bill date:

- Required
- ISO format:

```text
YYYY-MM-DD
```

Remark:

- Optional
- Maximum length: 255 characters
- Blank remarks are stored as `null`

### Successful response

```text
201 Created
```

```json
{
  "id": 10,
  "type": "EXPENSE",
  "category": "FOOD",
  "amount": 35.50,
  "billDate": "2026-07-16",
  "remark": "Lunch",
  "createdAt": "2026-07-16T15:40:00",
  "updatedAt": "2026-07-16T15:40:00"
}
```

## Get All Bills

```http
GET /api/bills
```

Bills are sorted by:

```text
billDate DESC
id DESC
```

### Successful response

```text
200 OK
```

```json
[
  {
    "id": 10,
    "type": "EXPENSE",
    "category": "FOOD",
    "amount": 35.50,
    "billDate": "2026-07-16",
    "remark": "Lunch",
    "createdAt": "2026-07-16T15:40:00",
    "updatedAt": "2026-07-16T15:40:00"
  }
]
```

## Filter Bills by Type

Income:

```http
GET /api/bills?type=INCOME
```

Expenses:

```http
GET /api/bills?type=EXPENSE
```

### Possible errors

```text
400 Bad Request — invalid type
401 Unauthorized — token is missing or invalid
```

## Get One Bill

```http
GET /api/bills/{id}
```

Example:

```http
GET /api/bills/10
```

### Successful response

```text
200 OK
```

```json
{
  "id": 10,
  "type": "EXPENSE",
  "category": "FOOD",
  "amount": 35.50,
  "billDate": "2026-07-16",
  "remark": "Lunch",
  "createdAt": "2026-07-16T15:40:00",
  "updatedAt": "2026-07-16T15:40:00"
}
```

### Possible errors

```text
401 Unauthorized — token is missing or invalid
404 Not Found — bill does not exist or belongs to another user
```

## Update Bill

```http
PUT /api/bills/{id}
```

Example:

```http
PUT /api/bills/10
```

### Request

```json
{
  "type": "EXPENSE",
  "category": "FOOD",
  "amount": 42.00,
  "billDate": "2026-07-16",
  "remark": "Lunch with colleagues"
}
```

The request must include all bill fields.

### Successful response

```text
200 OK
```

```json
{
  "id": 10,
  "type": "EXPENSE",
  "category": "FOOD",
  "amount": 42.00,
  "billDate": "2026-07-16",
  "remark": "Lunch with colleagues",
  "createdAt": "2026-07-16T15:40:00",
  "updatedAt": "2026-07-16T15:45:00"
}
```

### Possible errors

```text
400 Bad Request — invalid bill data
401 Unauthorized — token is missing or invalid
404 Not Found — bill does not exist or belongs to another user
```

## Delete Bill

```http
DELETE /api/bills/{id}
```

Example:

```http
DELETE /api/bills/10
```

### Successful response

```text
204 No Content
```

### Possible errors

```text
401 Unauthorized — token is missing or invalid
404 Not Found — bill does not exist or belongs to another user
```

# Statistics API

## Get Monthly Statistics

```http
GET /api/statistics/monthly
```

Authentication is required.

Without parameters, the current month is used.

### Specific month

```http
GET /api/statistics/monthly?year=2026&month=7
```

The `year` and `month` parameters must be provided together.

### Validation

Year:

```text
2000–2100
```

Month:

```text
1–12
```

### Successful response

```text
200 OK
```

```json
{
  "month": "2026-07",
  "totalIncome": 5500.00,
  "totalExpense": 2550.50,
  "balance": 2949.50,
  "expenseCategories": [
    {
      "category": "HOUSING",
      "amount": 1500.00
    },
    {
      "category": "FOOD",
      "amount": 620.50
    },
    {
      "category": "ENTERTAINMENT",
      "amount": 250.00
    },
    {
      "category": "TRANSPORT",
      "amount": 180.00
    }
  ]
}
```

The frontend uses this response for:

- Income card
- Expenses card
- Balance card
- Savings rate calculation
- Expense category ECharts diagram

Savings rate is calculated by the frontend:

```text
Savings Rate = Balance / Total Income × 100
```

### Possible errors

```text
400 Bad Request — invalid or incomplete year/month
401 Unauthorized — token is missing or invalid
```

# Health API

## Health Check

```http
GET /api/health
```

Authentication is not required.

### Successful response

```text
200 OK
```

Example:

```json
{
  "status": "UP"
}
```

# HTTP Status Codes

```text
200 OK
201 Created
204 No Content
400 Bad Request
401 Unauthorized
403 Forbidden
404 Not Found
409 Conflict
500 Internal Server Error
```

# Security Notes

- Passwords are stored only as BCrypt hashes.
- JWT tokens expire after the configured expiration time.
- Protected endpoints require a valid JWT.
- Bills are always filtered by the authenticated user's ID.
- Users cannot access another user's bills.
- Username is unique.
- Email is unique when provided.
- Monetary calculations use BigDecimal and MySQL DECIMAL.
- Profile updates cannot modify username or password.
