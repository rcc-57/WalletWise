# WalletWise

WalletWise is a personal online bookkeeping web application developed as part of the Software Production Internship.

The application allows users to create an account, manage income and expenses, review monthly statistics, update profile information, and select their preferred currency.

## Core Features

### Authentication

- User registration with username, password, and currency
- Username uniqueness validation
- BCrypt password hashing
- JWT-based authentication
- Protected frontend routes and backend endpoints
- Secure logout
- Current-user profile loading

### Bill Management

- Create income and expense records
- Edit existing records
- Delete records
- Filter records by type and category
- Search records by date, category, and remark
- Sort records by date and amount
- Fixed income and expense categories
- Reverse chronological backend sorting
- User data isolation

### Financial Statistics

- Monthly income
- Monthly expenses
- Monthly balance
- Savings rate
- Expense distribution by category
- Daily income and expense trend
- Recent transactions
- Month and year selection
- Automatic statistics recalculation after bill changes

### User Profile

- Display registered username
- Add or remove an email address
- Change preferred currency
- Persist profile changes in MySQL
- Display account creation date

## Technology Stack

### Frontend

- Vue 3
- Vue Router
- Pinia
- Element Plus
- Axios
- ECharts
- vue-echarts
- Vite

### Backend

- Java 17
- Spring Boot 3.5
- Spring Security
- JWT
- BCrypt
- MyBatis
- Jakarta Validation
- Maven

### Database

- MySQL 8
- DECIMAL for monetary values
- Foreign-key relationships
- Unique username and email constraints

## Project Structure

```text
WalletWise/
├── backend/
│   ├── src/main/java/com/walletwise/backend/
│   │   ├── config/
│   │   ├── controller/
│   │   ├── dto/
│   │   ├── entity/
│   │   ├── exception/
│   │   ├── mapper/
│   │   ├── security/
│   │   └── service/
│   ├── src/main/resources/
│   ├── pom.xml
│   ├── mvnw
│   └── mvnw.cmd
├── database/
│   ├── init.sql
│   ├── migrate-profile.sql
│   └── test-data.sql
├── documentation/
│   └── API.md
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── api/
│   │   ├── components/
│   │   ├── layouts/
│   │   ├── plugins/
│   │   ├── router/
│   │   ├── stores/
│   │   ├── utils/
│   │   └── views/
│   ├── package.json
│   └── vite.config.js
├── scripts/
│   └── smoke_test.py
├── start.command
└── README.md
```

## Database Model

WalletWise uses two main tables.

### users

Stores registered website users.

```text
id
username
password
email
currency
created_at
```

The password is stored as a BCrypt hash. The original plaintext password is never saved.

The email is optional and is initially `NULL`.

Currency is selected during registration and can later be changed from the Profile page.

Supported currencies:

```text
USD
EUR
GBP
CNY
RUB
```

### bills

Stores income and expense records.

```text
id
user_id
type
category
amount
bill_date
remark
created_at
updated_at
```

The `user_id` field connects each bill to its owner.

The backend always filters records by the authenticated user, preventing access to another user's financial data.

## Prerequisites

Install the following software:

- Java JDK 17
- MySQL 8
- Node.js `22.22.2+` or `24.15.0+`
- npm
- Git

Verify the installed versions:

```bash
java -version
node -v
npm -v
mysql --version
```

## Backend Configuration

The backend uses:

```text
backend/src/main/resources/application.properties
```

for general settings and:

```text
backend/src/main/resources/application-local.properties
```

for local database credentials and the JWT secret.

Create the local file from the example if it does not exist:

```bash
cd backend
cp src/main/resources/application-local.example.properties \
   src/main/resources/application-local.properties
```

Example configuration:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/online_bookkeeping?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=YOUR_REAL_MYSQL_PASSWORD
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

jwt.secret=YOUR_BASE64_JWT_SECRET
```

Generate a JWT secret:

```bash
openssl rand -base64 32
```

The real `application-local.properties` file must not be committed to Git.

## Automatic macOS Startup

WalletWise includes:

```text
start.command
```

The launcher:

1. Checks that Java, Node.js, npm, MySQL, and curl are available.
2. Checks the MySQL connection.
3. Creates the database automatically if it does not exist.
4. Verifies the required tables and profile fields.
5. Installs frontend dependencies.
6. Builds the frontend.
7. Builds the backend.
8. Starts the backend on port `8080`.
9. Starts the frontend on port `5173`.
10. Opens the application in the browser.

Give the launcher execution permission once:

```bash
chmod +x start.command
```

Daily startup procedure:

1. Start MySQL from macOS System Settings.
2. Double-click `start.command`.

Alternatively:

```bash
./start.command
```

Open the application at:

```text
http://localhost:5173
```

Press `Control+C` in the launcher terminal to stop both servers.

## Manual Database Initialization

To create the database manually:

```bash
mysql -u root -p < database/init.sql
```

The initialization script creates:

```text
online_bookkeeping
├── users
└── bills
```

Running `init.sql` again does not delete existing data because it uses:

```sql
CREATE DATABASE IF NOT EXISTS
CREATE TABLE IF NOT EXISTS
```

## Clean Database Reset

Warning: this permanently deletes all WalletWise users and bills.

Delete only the WalletWise database:

```bash
mysql -u root -p -e \
  "DROP DATABASE IF EXISTS online_bookkeeping;"
```

Then either execute:

```bash
mysql -u root -p < database/init.sql
```

or start `start.command`. The launcher will automatically recreate the missing database.

After a clean reset, do not run `migrate-profile.sql`, because the latest `init.sql` already includes email and currency fields.

## Database Migration

The migration file:

```text
database/migrate-profile.sql
```

exists only for databases created with an older version of WalletWise.

It adds:

```text
email
currency
```

to an existing `users` table.

Run it only once on an old database:

```bash
mysql -u root -p < database/migrate-profile.sql
```

Do not run it after creating a new database with the latest `init.sql`.

## Optional Test Data

The file:

```text
database/test-data.sql
```

creates an optional demonstration account and several bills.

Demo credentials:

```text
Username: demo_walletwise
Password: Demo123!
Currency: USD
```

Load the optional data:

```bash
mysql -u root -p < database/test-data.sql
```

The application does not require this account. Normal users can register through the website.

Do not execute `test-data.sql` when preparing an empty final database.

## Manual Backend Startup

Start MySQL first.

From the backend directory:

```bash
cd backend
chmod +x mvnw
./mvnw spring-boot:run
```

The backend starts at:

```text
http://localhost:8080
```

Health check:

```bash
curl http://localhost:8080/api/health
```

## Manual Frontend Startup

From the frontend directory:

```bash
cd frontend
npm install
npm run dev
```

The development server normally starts at:

```text
http://localhost:5173
```

## Production Builds

### Backend

```bash
cd backend
./mvnw clean package
```

The generated JAR is located at:

```text
backend/target/backend-0.0.1-SNAPSHOT.jar
```

Run the JAR:

```bash
java -jar target/backend-0.0.1-SNAPSHOT.jar
```

### Frontend

```bash
cd frontend
npm install
npm run build
```

The generated frontend is located at:

```text
frontend/dist/
```

Preview the build:

```bash
npm run preview
```

## Frontend Routes

Public routes:

```text
/login
/register
```

Protected routes:

```text
/dashboard
/expenses
/income
/profile
```

The former Analytics page was merged into Dashboard to avoid duplicate statistics and charts.

The Settings page was removed. Currency selection is available in Profile and is stored in MySQL.

## API Overview

### Authentication and Profile

```text
POST /api/auth/register
POST /api/auth/login
GET  /api/auth/me
PUT  /api/auth/me
```

### Bills

```text
POST   /api/bills
GET    /api/bills
GET    /api/bills/{id}
PUT    /api/bills/{id}
DELETE /api/bills/{id}
```

### Statistics

```text
GET /api/statistics/monthly
```

### Health

```text
GET /api/health
```

Detailed API documentation is available in:

```text
documentation/API.md
```

## Authentication Flow

1. The user registers or logs in.
2. The backend validates the request.
3. The backend creates a signed JWT.
4. The frontend stores the token in `localStorage`.
5. Axios adds the token to protected requests:

```http
Authorization: Bearer <token>
```

6. Spring Security validates the token.
7. The backend identifies the current user.
8. Protected endpoints return only that user's data.

## Financial Calculations

All monetary values use:

```text
BigDecimal
```

in Java and:

```text
DECIMAL(12, 2)
```

in MySQL.

This prevents precision problems associated with `float` and `double`.

Monthly balance:

```text
Balance = Total Income - Total Expenses
```

Savings rate:

```text
Savings Rate = Balance / Total Income × 100
```

Savings rate is calculated from database values and is not stored separately.

## Data Visualization

WalletWise uses ECharts through `vue-echarts`.

Dashboard includes:

- Daily income and expense line chart
- Expense category pie chart

All chart data comes from the authenticated user's bills and monthly statistics.

Chart.js and static mock datasets are not used.

## Smoke Test

Start MySQL and the backend before running:

```bash
python3 scripts/smoke_test.py
```

The smoke test checks:

- Registration with currency
- JWT authentication
- Profile update
- Email persistence
- Currency persistence
- Duplicate username handling
- Duplicate email handling
- Bill creation
- Bill filtering
- User data isolation
- Monthly statistics
- Bill update
- Validation
- Bill deletion

Important: each smoke-test run creates test users in the database.

Do not run it on the final demonstration database after the final reset.

## Security

WalletWise implements:

- BCrypt password hashing
- JWT authentication
- Stateless Spring Security
- Protected API endpoints
- User data isolation
- Request validation
- Username uniqueness
- Email uniqueness
- Fixed bill categories
- CORS configuration for local frontend development

## Final Demonstration Preparation

Recommended procedure:

1. Delete the old `online_bookkeeping` database.
2. Start MySQL.
3. Run `start.command`.
