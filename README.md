# WalletWise

WalletWise is a personal online bookkeeping web application built with a Spring Boot backend and a Vue 3 frontend. It allows users to register, log in, track income and expenses, and view monthly financial statistics.

## Technology Stack

### Backend

- Java 17
- Spring Boot 3.5
- Spring Security
- JWT authentication
- MyBatis
- MySQL 8
- Maven
- BCrypt password hashing

### Frontend

- Vue 3
- Vue Router
- Pinia
- Element Plus
- Axios
- ECharts
- Vite

## Repository Structure

```text
WalletWise/
├── backend/          Spring Boot backend
├── database/         Database scripts
├── frontend/         Vue frontend application
├── documentation/    Project documentation
├── scripts/          Smoke test script
└── README.md         Project documentation
```

## Prerequisites

Install the following software before running WalletWise:

- Git
- Java JDK 17
- MySQL 8
- Node.js 22.18.0 or newer (or Node 24.12.0+)
- npm

## Required Software Versions

- Java: 17
- MySQL: 8.x
- Node.js: ^22.18.0 or >=24.12.0
- npm: compatible with installed Node.js

## Database Setup

### 1. Create the database and tables

Open a terminal in the repository root:

```bash
cd c:/Users/User/Documents/GitHub/WalletWise
```

Run the initialization script:

```bash
mysql -u root -p < database/init.sql
```

### 2. Load demo data

Run:

```bash
mysql -u root -p < database/test-data.sql
```

### Demo credentials

- Username: `demo_walletwise`
- Password: `Demo123!`

## Backend Configuration

### 1. Create local application properties

Copy the example backend configuration file:

```bash
cd backend
copy src\main\resources\application-local.example.properties src\main\resources\application-local.properties
```

Edit `backend/src/main/resources/application-local.properties` and set your MySQL credentials and JWT secret.

### 2. Required backend properties

The file should include:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/online_bookkeeping?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=YOUR_MYSQL_PASSWORD
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

jwt.secret=YOUR_GENERATED_JWT_SECRET
```

`jwt.secret` must be a valid Base64-encoded secret. Example generation command:

```bash
openssl rand -base64 32
```

### 3. Backend configuration file details

The backend uses `backend/src/main/resources/application.properties` for runtime settings:

- `spring.application.name=walletwise-backend`
- `spring.profiles.active=local`
- `server.port=8080`
- `mybatis.configuration.map-underscore-to-camel-case=true`
- `jwt.expiration-ms=86400000`

## JWT Configuration

The backend signs and validates JWT tokens using the secret configured in `jwt.secret` and expires tokens after `86400000` milliseconds (24 hours).

## Running MySQL

Start your local MySQL server and ensure it is accessible on `localhost:3306`. Use the configured username and password from `application-local.properties`.

## Running the Backend

From the root directory:

```bash
cd backend
./mvnw spring-boot:run
```

On Windows:

```bash
cd backend
mvnw.cmd spring-boot:run
```

The backend starts on:

```text
http://localhost:8080
```

## Backend Health Check

Verify the backend is running:

```bash
curl http://localhost:8080/api/health
```

## Frontend Configuration

### 1. Install dependencies

From the frontend folder:

```bash
cd frontend
npm install
```

### 2. Axios base URL

The frontend Axios client is configured in `frontend/src/api/client.js` with:

```js
baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'
```

If you need to override the backend URL, set `VITE_API_BASE_URL` in your shell or Vite environment.

### 3. Vite environment variables

The frontend reads `VITE_API_BASE_URL` from `import.meta.env`.

## Running the Frontend

From the frontend directory:

```bash
cd frontend
npm run dev
```

Open the local address shown by Vite, typically:

```text
http://localhost:5173
```

## Available Frontend Pages

Configured in `frontend/src/router/index.js`:

- `/login` — Login page
- `/register` — Registration page
- `/dashboard` — Dashboard page (authenticated)
- `/expenses` — Expenses management
- `/income` — Income management
- `/analytics` — Financial analytics
- `/profile` — User profile
- `/settings` — App settings

The root `/` redirects to `/login`.

## Available Backend APIs

### Auth APIs
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/me`

### Bill APIs
- `POST /api/bills`
- `GET /api/bills`
- `GET /api/bills/{id}`
- `PUT /api/bills/{id}`
- `DELETE /api/bills/{id}`

### Statistics APIs
- `GET /api/statistics/monthly`

### Health API
- `GET /api/health`

## Authentication Flow

1. User registers via `POST /api/auth/register`.
2. Backend responds with a JWT and user details.
3. User logs in via `POST /api/auth/login`.
4. Frontend stores the token in `localStorage` under `walletwise_token`.
5. Axios attaches `Authorization: Bearer <token>` to API requests.
6. Backend verifies the JWT with `JwtAuthenticationFilter`.
7. Protected endpoints require authentication.

## Project Architecture

### Backend
- `backend/src/main/java/com/walletwise/backend/config/` — security and CORS configuration.
- `backend/src/main/java/com/walletwise/backend/controller/` — REST controllers.
- `backend/src/main/java/com/walletwise/backend/dto/` — request and response DTOs.
- `backend/src/main/java/com/walletwise/backend/security/` — JWT auth and token handling.
- `backend/src/main/resources/` — properties files.

### Frontend
- `frontend/src/api/` — Axios client.
- `frontend/src/router/` — application routes.
- `frontend/src/stores/` — Pinia state management.
- `frontend/src/views/` — page views.
- `frontend/src/components/` — reusable UI components.
- `frontend/src/layouts/` — layout components.

## API Communication Flow

- Frontend requests go through `frontend/src/api/client.js`.
- Axios uses `VITE_API_BASE_URL` or `http://localhost:8080`.
- Authorization headers are attached when a token exists.
- Backend controllers use Spring Security authentication context.

## Database Scripts

- `database/init.sql` — creates the `online_bookkeeping` database, `users`, and `bills` tables.
- `database/test-data.sql` — inserts a demo user and demo bills.

## Demo Credentials

- Username: `demo_walletwise`
- Password: `Demo123!`

## Build Commands

### Backend
- `./mvnw clean package`
- `./mvnw spring-boot:run`

### Frontend
- `npm install`
- `npm run dev`
- `npm run build`
- `npm run preview`

## Development Commands

### Backend
```bash
cd backend
./mvnw spring-boot:run
```

### Frontend
```bash
cd frontend
npm install
npm run dev
```

## Production Build Commands

### Backend
```bash
cd backend
./mvnw clean package
```

### Frontend
```bash
cd frontend
npm install
npm run build
```

## Common Troubleshooting

- If the frontend cannot reach the backend, verify `VITE_API_BASE_URL` or use the default `http://localhost:8080`.
- If backend startup fails, confirm MySQL is running and the connection properties in `application-local.properties` are correct.
- If JWT validation fails, ensure `jwt.secret` is a Base64 string and the same secret is used for all requests.
- If there are CORS issues, check backend `SecurityConfig` allows `http://localhost:*` and `http://127.0.0.1:*`.

## Notes

- Backend runs on port `8080`.
- Frontend Vite server typically runs on port `5173`.
- Demo account and data are defined in `database/test-data.sql`.
- presentation materials;
- runnable demonstration version.