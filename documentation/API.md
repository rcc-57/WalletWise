# WalletWise API

Base URL:

http://localhost:8080

## Authentication

### Register

POST /api/auth/register

Request:

{
  "username": "ivan",
  "password": "password123"
}

### Login

POST /api/auth/login

Request:

{
  "username": "ivan",
  "password": "password123"
}

The response contains a JWT token.

Protected requests must include:

Authorization: Bearer <token>

### Current user

GET /api/auth/me

## Bills

### Get all bills

GET /api/bills

Optional filter:

GET /api/bills?type=INCOME
GET /api/bills?type=EXPENSE

### Get one bill

GET /api/bills/{id}

### Create bill

POST /api/bills

Request:

{
  "type": "EXPENSE",
  "category": "FOOD",
  "amount": 35.50,
  "billDate": "2026-07-13",
  "remark": "Lunch"
}

### Update bill

PUT /api/bills/{id}

### Delete bill

DELETE /api/bills/{id}

## Categories

Income:

SALARY
BONUS
INVESTMENT
OTHER

Expense:

FOOD
TRANSPORT
SHOPPING
HOUSING
HEALTH
EDUCATION
ENTERTAINMENT
OTHER

## Statistics

GET /api/statistics/monthly

Specific month:

GET /api/statistics/monthly?year=2026&month=7

Response:

{
  "month": "2026-07",
  "totalIncome": 5000.00,
  "totalExpense": 1000.00,
  "balance": 4000.00,
  "expenseCategories": [
    {
      "category": "FOOD",
      "amount": 700.00
    }
  ]
}
