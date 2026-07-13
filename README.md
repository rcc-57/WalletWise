# WalletWise

WalletWise is a personal online bookkeeping web application developed during the Software Production Internship.

The system allows users to securely manage income and expense records and view monthly financial statistics.

## Technology Stack

### Backend

- Java 17
- Spring Boot 3.5
- Spring Security
- JWT
- MyBatis
- MySQL 8
- Maven

### Frontend

- Vue 3
- Element Plus
- Axios
- ECharts

## Main Features

- User registration and login
- BCrypt password hashing
- JWT authentication
- User data isolation
- Create, read, update, and delete bills
- Income and expense filtering
- Reverse chronological bill ordering
- Monthly income, expense, and balance calculation
- Expense distribution by category
- REST API validation
- Structured error responses
- CORS support for the Vue frontend

## Project Structure

```text
WalletWise/
├── backend/          Spring Boot backend
├── frontend/         Vue frontend
├── database/         Database scripts
├── documentation/    Project documentation
├── scripts/          Automated smoke tests
└── README.md
```

## Requirements

Install the following software:

- JDK 17
- MySQL 8.0
- Git
- Node.js 20 or newer
- npm

IntelliJ IDEA is recommended for backend development. Visual Studio Code can be used for frontend development.

## Database Setup

Open Terminal in the root directory of the project:

```bash
cd ~/Documents/GitHub/WalletWise
```

Create the database and tables:

```bash
mysql -u root -p < database/init.sql
```

Add demonstration data:

```bash
mysql -u root -p < database/test-data.sql
```

The test-data script creates a demonstration account:

```text
Username: demo_walletwise
Password: Demo123!
```

This account is intended only for local testing and project demonstration.

## Backend Configuration

Inside the following directory:

```text
backend/src/main/resources/
```

copy:

```text
application-local.example.properties
```

and rename the copy to:

```text
application-local.properties
```

Configure the local MySQL connection:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/online_bookkeeping?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=YOUR_MYSQL_PASSWORD
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

Generate a JWT secret:

```bash
openssl rand -base64 32
```

Add the generated secret to `application-local.properties`:

```properties
jwt.secret=YOUR_GENERATED_JWT_SECRET
```

The complete local file should look similar to this:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/online_bookkeeping?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=YOUR_MYSQL_PASSWORD
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

jwt.secret=YOUR_GENERATED_JWT_SECRET
```

The `application-local.properties` file is excluded from Git because it contains local passwords and secrets.

## Running the Backend

Open Terminal and run:

```bash
cd ~/Documents/GitHub/WalletWise/backend
./mvnw spring-boot:run
```

Wait until the following message appears:

```text
Started BackendApplication
```

The backend will be available at:

```text
http://localhost:8080
```

To stop the backend, press:

```text
Control + C
```

## Backend Health Check

With the backend running, open another Terminal window and execute:

```bash
curl http://localhost:8080/api/health
```

Expected response:

```json
{
  "status": "UP",
  "database": "UP"
}
```

## Running Backend Smoke Tests

Keep the backend running in one Terminal window.

Open another Terminal window and run:

```bash
cd ~/Documents/GitHub/WalletWise
python3 scripts/smoke_test.py
```

Expected final result:

```text
All WalletWise backend smoke tests passed.
```

The smoke test verifies:

- user registration;
- user login;
- JWT authentication;
- duplicate username handling;
- invalid password handling;
- bill creation;
- bill filtering;
- bill editing;
- bill deletion;
- input validation;
- monthly statistics;
- isolation of different users' data.

## Authentication API

### Register

```http
POST /api/auth/register
```

Request:

```json
{
  "username": "ivan",
  "password": "password123"
}
```

### Login

```http
POST /api/auth/login
```

Request:

```json
{
  "username": "ivan",
  "password": "password123"
}
```

Successful registration and login responses contain a JWT token:

```json
{
  "token": "JWT_TOKEN",
  "tokenType": "Bearer",
  "user": {
    "id": 1,
    "username": "ivan",
    "createdAt": "2026-07-14T10:00:00"
  }
}
```

Protected requests must include the following HTTP header:

```http
Authorization: Bearer JWT_TOKEN
```

### Get Current User

```http
GET /api/auth/me
```

This endpoint requires a valid JWT.

## Bill API

### Get All Bills

```http
GET /api/bills
```

### Filter Bills by Type

```http
GET /api/bills?type=INCOME
```

```http
GET /api/bills?type=EXPENSE
```

### Get One Bill

```http
GET /api/bills/{id}
```

### Create a Bill

```http
POST /api/bills
```

Request:

```json
{
  "type": "EXPENSE",
  "category": "FOOD",
  "amount": 35.50,
  "billDate": "2026-07-13",
  "remark": "Lunch"
}
```

### Update a Bill

```http
PUT /api/bills/{id}
```

Request:

```json
{
  "type": "EXPENSE",
  "category": "FOOD",
  "amount": 42.00,
  "billDate": "2026-07-13",
  "remark": "Lunch and coffee"
}
```

### Delete a Bill

```http
DELETE /api/bills/{id}
```

A successful deletion returns:

```text
HTTP 204 No Content
```

## Supported Categories

### Income Categories

- `SALARY`
- `BONUS`
- `INVESTMENT`
- `OTHER`

### Expense Categories

- `FOOD`
- `TRANSPORT`
- `SHOPPING`
- `HOUSING`
- `HEALTH`
- `EDUCATION`
- `ENTERTAINMENT`
- `OTHER`

## Statistics API

### Current Month

```http
GET /api/statistics/monthly
```

### Selected Month

```http
GET /api/statistics/monthly?year=2026&month=7
```

Example response:

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

## Error Responses

The backend returns structured error responses.

Example:

```json
{
  "timestamp": "2026-07-14T10:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Amount must be greater than zero",
  "path": "/api/bills"
}
```

Common status codes:

- `400 Bad Request` — invalid request data;
- `401 Unauthorized` — missing or invalid JWT;
- `403 Forbidden` — access is denied;
- `404 Not Found` — resource does not exist or belongs to another user;
- `409 Conflict` — username or data conflict.

## CORS

The backend accepts development requests from local frontend servers, including:

```text
http://localhost:5173
http://127.0.0.1:5173
```

Other local ports are also supported during development.

## Security

- Passwords are stored as BCrypt hashes.
- Plain-text passwords are never stored in the database.
- JWT authentication is used for protected endpoints.
- Every bill query includes the authenticated user's identifier.
- Users cannot access, modify, or delete another user's bills.
- Local database passwords and JWT secrets are excluded from Git.
- Monetary values use MySQL `DECIMAL` and Java `BigDecimal`.
- SQL queries use MyBatis parameters instead of concatenated user input.

## API Documentation

Detailed API information is also available in:

```text
documentation/API.md
```

## Git Workflow

Backend development is performed in:

```text
ivan_branch
```

Frontend development should be performed in a separate branch.

Completed and tested changes are merged into:

```text
main
```

through a pull request.

## Final Project Deliverables

The final project package must include:

- complete backend source code;
- complete frontend source code;
- database creation script;
- test-data script;
- project documentation;
- diagrams;
- presentation materials;
- runnable demonstration version.