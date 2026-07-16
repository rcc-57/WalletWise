# WalletWise

WalletWise is an online personal bookkeeping application built with Spring Boot, Vue 3 and MySQL.

Users can create an account, record income and expenses, manage their profile and view monthly financial statistics.

## Features

- Registration and login
- JWT authentication
- BCrypt password hashing
- Unique usernames
- Optional email address
- User-selected currency
- Income creation, editing and deletion
- Expense creation, editing and deletion
- Transaction filtering
- Monthly income, expenses and balance calculation
- Savings rate calculation
- Daily cash-flow chart
- Expense category chart
- Recent transactions
- Profile data stored in MySQL

## Technology Stack

### Backend

- Java 17
- Spring Boot 3.5
- Spring Security
- JWT
- MyBatis
- MySQL 8
- Maven Wrapper
- BCrypt

### Frontend

- Vue 3
- Vue Router
- Pinia
- Element Plus
- Axios
- ECharts
- Vite

## Project Structure

```text
WalletWise/
├── backend/                 Spring Boot backend
├── database/                Database initialization scripts
├── documentation/           Project and API documentation
├── frontend/                Vue frontend
├── scripts/                 Optional test scripts
├── start.command            macOS startup script
├── start-windows.bat        Windows startup launcher
├── start-windows.ps1        Windows startup script
├── .gitignore
└── README.md
```

## Prerequisites

Install the following software before starting WalletWise:

- Git
- Java JDK 17
- MySQL 8
- Node.js `^22.22.2` or `>=24.15.0`
- npm

MySQL must be running before WalletWise is launched.

The MySQL command-line client must also be installed. It is normally installed together with MySQL Server.

## Passwords and Local Configuration

Real passwords and JWT secrets must never be committed to GitHub.

The repository contains only the safe configuration template:

```text
backend/src/main/resources/application-local.example.properties
```

The real local configuration is stored in:

```text
backend/src/main/resources/application-local.properties
```

This file is excluded from Git using `.gitignore`.

During the first automatic launch, the startup script asks for:

- MySQL username;
- MySQL password.

The default MySQL username is:

```text
root
```

The script then creates `application-local.properties` and generates a random JWT secret.

Every computer has its own local configuration, MySQL password, JWT secret and database.

The MySQL password is not the WalletWise website password. It is the password that was configured for the MySQL `root` user during MySQL installation.

## First Launch After Cloning

Clone the project:

```bash
git clone YOUR_REPOSITORY_URL
```

Open the project directory:

```bash
cd WalletWise
```

Start MySQL.

Then use the startup script for your operating system.

During the first launch:

1. The script asks for the local MySQL username.
2. The script asks for the local MySQL password.
3. The script creates the private local configuration.
4. The script generates a JWT secret.
5. The script connects to MySQL.
6. The script creates the database if it does not exist.
7. The script builds the frontend and backend.
8. The script starts WalletWise.
9. The browser opens at `http://localhost:5173`.

Future launches reuse the local configuration and do not ask for the password again.

## Automatic Launch on macOS

First, start MySQL in macOS System Settings or using the installed MySQL management application.

Then double-click:

```text
start.command
```

The script automatically:

1. Creates local configuration during the first launch.
2. Checks Java, Node.js, npm and MySQL.
3. Connects to the local MySQL server.
4. Creates `online_bookkeeping` if it does not exist.
5. Executes `database/init.sql` for a new database.
6. Installs frontend dependencies.
7. Builds the frontend.
8. Builds the backend.
9. Starts the backend.
10. Starts the frontend.
11. Opens `http://localhost:5173`.

The Terminal window must remain open while WalletWise is running.

Press Enter inside the Terminal window to stop the application.

### macOS Permission

If macOS does not allow `start.command` to run, open Terminal in the project directory and execute:

```bash
chmod +x start.command
```

If the project is being prepared for Git, preserve the executable permission:

```bash
git update-index --chmod=+x start.command
```

After that, double-click `start.command` again.

## Automatic Launch on Windows

First, start MySQL using Windows Services, MySQL Installer or MySQL Workbench.

Then double-click:

```text
start-windows.bat
```

Do not launch `start-windows.ps1` directly.

The BAT file launches the PowerShell startup script with the required execution settings.

The Windows script:

1. Creates local configuration during the first launch.
2. Checks Java, Node.js, npm and MySQL.
3. Connects to the local MySQL server.
4. Creates `online_bookkeeping` if it does not exist.
5. Executes `database/init.sql` for a new database.
6. Installs frontend dependencies.
7. Builds the frontend.
8. Builds the backend.
9. Starts both parts of the application.
10. Opens `http://localhost:5173`.

The command window must remain open while WalletWise is running.

Press Enter inside the command window to stop the application.

## Application Addresses

Frontend:

```text
http://localhost:5173
```

Backend:

```text
http://localhost:8080
```

Backend health check:

```text
http://localhost:8080/api/health
```

The application uses HTTP on localhost. Local HTTPS configuration is not required for this educational project.

## Database Initialization

The startup scripts automatically check whether this database exists:

```text
online_bookkeeping
```

If the database does not exist, the script executes:

```text
database/init.sql
```

If the database already exists, existing users and transactions are preserved.

The database is not deleted during normal startup.

### Manual Database Initialization

If automatic initialization is not being used, run:

```bash
mysql -u root -p < database/init.sql
```

MySQL will ask for the local `root` password.

## Clean Database Reset

Warning: the following command deletes every WalletWise website user and every transaction.

```bash
mysql -u root -p -e "DROP DATABASE IF EXISTS online_bookkeeping;"
```

After running the command, launch the appropriate startup script again.

The script will detect that the database is missing and will execute:

```text
database/init.sql
```

For a clean final demonstration:

1. Stop WalletWise.
2. Delete the old `online_bookkeeping` database.
3. Start MySQL.
4. Launch WalletWise.
5. Register one demonstration website user.
6. Add several understandable income records.
7. Add several understandable expense records.
8. Check the dashboard and charts.
9. Log out and log in again.
10. Verify that the data remains available.

Do not execute `database/test-data.sql` unless demo records are specifically required.

Do not execute `scripts/smoke_test.py` before the final demonstration because it creates additional test users.

## Database Structure

### `users`

The `users` table stores:

- `id` — website user ID;
- `username` — unique username;
- `password` — BCrypt password hash;
- `email` — optional email address;
- `currency` — selected currency;
- `created_at` — real account creation date and time.

The creation date is generated and stored by MySQL.

It can be viewed with:

```sql
USE online_bookkeeping;

SELECT id, username, email, currency, created_at
FROM users;
```

### `bills`

The `bills` table stores:

- bill ID;
- owner user ID;
- income or expense type;
- amount;
- category;
- description;
- transaction date;
- creation date and time.

Each bill belongs to one website user through `user_id`.

### MySQL Root and Website Users

The MySQL `root` user is the database server administrator.

It is not a WalletWise website account and must not be inserted into the `users` table.

WalletWise website users register through the registration page. Their accounts are stored inside the `users` table.

The backend reads the JWT and ensures that every website user can access only their own transactions.

## Backend Local Configuration

The local file contains properties similar to:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/online_bookkeeping?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=LOCAL_MYSQL_PASSWORD
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

jwt.secret=LOCAL_GENERATED_BASE64_SECRET
```

This file must never be uploaded to GitHub:

```text
backend/src/main/resources/application-local.properties
```

The safe example file can be uploaded:

```text
backend/src/main/resources/application-local.example.properties
```

## Manual Backend Launch

Before manual backend launch, make sure that:

- MySQL is running;
- `online_bookkeeping` exists;
- `application-local.properties` exists;
- the local MySQL password is correct.

### macOS and Linux

```bash
cd backend
./mvnw spring-boot:run
```

### Windows

```bat
cd backend
mvnw.cmd spring-boot:run
```

The backend starts at:

```text
http://localhost:8080
```

## Manual Frontend Launch

Open another terminal:

```bash
cd frontend
npm install
npm run dev
```

The frontend starts at:

```text
http://localhost:5173
```

## Frontend Pages

- `/login` — user login
- `/register` — user registration and currency selection
- `/dashboard` — financial summary and charts
- `/expenses` — expense management
- `/income` — income management
- `/profile` — username, email and currency

Protected pages require a valid JWT.

## Main API Endpoints

### Authentication

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/me`
- `PUT /api/auth/me`

### Bills

- `POST /api/bills`
- `GET /api/bills`
- `GET /api/bills/{id}`
- `PUT /api/bills/{id}`
- `DELETE /api/bills/{id}`

### Statistics

- `GET /api/statistics/monthly`

### Health

- `GET /api/health`

Detailed API documentation is available in:

```text
documentation/API.md
```

## Authentication Flow

1. A user registers or logs in.
2. The backend validates the request.
3. Website passwords are stored only as BCrypt hashes.
4. The backend generates a JWT.
5. The frontend stores the JWT in `localStorage`.
6. Axios adds the token to protected API requests.
7. The backend validates the JWT.
8. The backend determines the current website user.
9. Every user receives only their own profile and transactions.

## Currency Support

WalletWise supports:

- USD — US Dollar
- EUR — Euro
- GBP — British Pound
- CNY — Chinese Yuan
- RUB — Russian Ruble

The currency is selected during registration.

It can later be changed on the profile page.

The selected currency is stored in the MySQL `users` table.

## Financial Statistics

The dashboard displays:

- monthly income;
- monthly expenses;
- monthly balance;
- savings rate;
- daily income and expense chart;
- expense category chart;
- recent transactions.

The dashboard data is loaded from the backend and calculated using records stored in MySQL.

Savings rate is calculated dynamically and is not stored as a separate database value.

## ECharts

WalletWise uses ECharts through `vue-echarts`.

The charts display real financial data received from the backend.

The project does not use static mock chart data.

## Security Notes

Never commit:

- `application-local.properties`;
- real MySQL passwords;
- JWT secrets;
- generated backend JAR files;
- `backend/target`;
- `frontend/node_modules`;
- `frontend/dist`;
- IDE configuration;
- `.DS_Store`;
- `__MACOSX`.

If a real MySQL password was previously committed, removing the file from the latest commit is not sufficient because it may remain in Git history.

In that situation:

1. Remove the file from Git tracking.
2. Change the MySQL password.
3. Update the local configuration with the new password.

## Optional Smoke Test

The optional smoke test is located at:

```text
scripts/smoke_test.py
```

It checks registration, profile updates, bill operations and statistics.

The smoke test creates test website users and test bills.

Do not run it against the clean final demonstration database unless test data is acceptable.

## Final Demonstration Checklist

Before the final demonstration, verify that:

- MySQL starts successfully;
- the operating-system startup script works;
- the frontend opens at `http://localhost:5173`;
- registration works;
- currency is required during registration;
- login works;
- logout works;
- username is loaded from the database;
- email is empty until the user adds it;
- email is saved in the database;
- currency is saved in the database;
- income creation works;
- income editing works;
- income deletion works;
- expense creation works;
- expense editing works;
- expense deletion works;
- data remains after page refresh;
- data remains after logout and login;
- dashboard values use database data;
- ECharts displays real database data;
- account creation dates are stored in MySQL;
- different users cannot access each other's data;
- no real passwords are present in GitHub;
- `application-local.properties` is not tracked by Git.

## Git Safety Check

Before pushing to GitHub, run:

```bash
git status
```

Check whether the local configuration is tracked:

```bash
git ls-files backend/src/main/resources/application-local.properties
```

The command must print nothing.

If it prints the filename, execute:

```bash
git rm --cached backend/src/main/resources/application-local.properties
```

Then commit the `.gitignore` change.

## Final Submission

The final submission should include:

- frontend source code;
- backend source code;
- database initialization script;
- optional test data script;
- API documentation;
- README;
- required report;
- project presentation.

Generated directories and private configuration files must not be included.
