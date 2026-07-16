#!/bin/bash

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
FRONTEND_DIR="$ROOT_DIR/frontend"
DATABASE_DIR="$ROOT_DIR/database"
LOG_DIR="$ROOT_DIR/logs"

CONFIG_FILE="$BACKEND_DIR/src/main/resources/application-local.properties"
EXAMPLE_CONFIG="$BACKEND_DIR/src/main/resources/application-local.example.properties"
INIT_SQL="$DATABASE_DIR/init.sql"

BACKEND_PID=""
FRONTEND_PID=""

mkdir -p "$LOG_DIR"

print_step() {
  echo
  echo "============================================================"
  echo "$1"
  echo "============================================================"
}

stop_processes() {
  echo
  echo "Stopping WalletWise..."

  if [ -n "$FRONTEND_PID" ] && kill -0 "$FRONTEND_PID" 2>/dev/null; then
    kill "$FRONTEND_PID" 2>/dev/null || true
  fi

  if [ -n "$BACKEND_PID" ] && kill -0 "$BACKEND_PID" 2>/dev/null; then
    kill "$BACKEND_PID" 2>/dev/null || true
  fi
}

finish_with_error() {
  echo
  echo "ERROR: $1"
  echo
  read -r -p "Press Enter to close..."
  exit 1
}

trap stop_processes EXIT INT TERM

get_property() {
  local property_name="$1"
  local file_name="$2"

  awk -v key="$property_name" '
    index($0, key "=") == 1 {
      sub("^[^=]*=", "")
      print
      exit
    }
  ' "$file_name"
}

create_local_config() {
  print_step "First-time local configuration"

  echo "The MySQL password will be stored only on this computer."
  echo "The local configuration file is excluded from Git."
  echo

  read -r -p "MySQL username [root]: " DB_USERNAME
  DB_USERNAME="${DB_USERNAME:-root}"

  read -r -s -p "MySQL password: " DB_PASSWORD
  echo

  if [ -z "$DB_PASSWORD" ]; then
    finish_with_error "MySQL password cannot be empty."
  fi

  if ! command -v openssl >/dev/null 2>&1; then
    finish_with_error "OpenSSL is required to generate the JWT secret."
  fi

  JWT_SECRET="$(openssl rand -base64 32 | tr -d '\n')"

  cat > "$CONFIG_FILE" <<EOF
spring.datasource.url=jdbc:mysql://localhost:3306/online_bookkeeping?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=$DB_USERNAME
spring.datasource.password=$DB_PASSWORD
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

jwt.secret=$JWT_SECRET
EOF

  chmod 600 "$CONFIG_FILE"

  echo
  echo "Local configuration created:"
  echo "$CONFIG_FILE"
}

if [ ! -d "$BACKEND_DIR" ] ||
   [ ! -d "$FRONTEND_DIR" ] ||
   [ ! -f "$INIT_SQL" ]; then
  finish_with_error "Run this file from the WalletWise project directory."
fi

if [ ! -f "$CONFIG_FILE" ]; then
  create_local_config
fi

DB_USERNAME="$(get_property "spring.datasource.username" "$CONFIG_FILE")"
DB_PASSWORD="$(get_property "spring.datasource.password" "$CONFIG_FILE")"

if [ -z "$DB_USERNAME" ]; then
  finish_with_error "spring.datasource.username is missing in application-local.properties."
fi

if [ -z "$DB_PASSWORD" ] ||
   [ "$DB_PASSWORD" = "YOUR_MYSQL_PASSWORD" ] ||
   [ "$DB_PASSWORD" = "YOUR_PASSWORD" ]; then
  finish_with_error "Set a real MySQL password in application-local.properties."
fi

print_step "Checking required software"

command -v java >/dev/null 2>&1 ||
  finish_with_error "Java 17 is not installed or is not available in PATH."

command -v node >/dev/null 2>&1 ||
  finish_with_error "Node.js is not installed or is not available in PATH."

command -v npm >/dev/null 2>&1 ||
  finish_with_error "npm is not installed or is not available in PATH."

command -v curl >/dev/null 2>&1 ||
  finish_with_error "curl is not installed or is not available in PATH."

MYSQL_BIN=""

if command -v mysql >/dev/null 2>&1; then
  MYSQL_BIN="$(command -v mysql)"
elif [ -x "/usr/local/mysql/bin/mysql" ]; then
  MYSQL_BIN="/usr/local/mysql/bin/mysql"
elif [ -x "/opt/homebrew/bin/mysql" ]; then
  MYSQL_BIN="/opt/homebrew/bin/mysql"
elif [ -x "/usr/local/bin/mysql" ]; then
  MYSQL_BIN="/usr/local/bin/mysql"
else
  finish_with_error "MySQL command-line client was not found."
fi

echo "Java: $(java -version 2>&1 | head -n 1)"
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"
echo "MySQL client: $MYSQL_BIN"

print_step "Checking MySQL"

if ! MYSQL_PWD="$DB_PASSWORD" "$MYSQL_BIN" \
  --host=127.0.0.1 \
  --port=3306 \
  --user="$DB_USERNAME" \
  --batch \
  --skip-column-names \
  -e "SELECT 1;" >/dev/null 2>&1; then
  finish_with_error "Cannot connect to MySQL. Start MySQL and check the local password."
fi

DATABASE_EXISTS="$(
  MYSQL_PWD="$DB_PASSWORD" "$MYSQL_BIN" \
    --host=127.0.0.1 \
    --port=3306 \
    --user="$DB_USERNAME" \
    --batch \
    --skip-column-names \
    -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'online_bookkeeping';"
)"

if [ "$DATABASE_EXISTS" != "online_bookkeeping" ]; then
  echo "Database not found. Running database/init.sql..."

  MYSQL_PWD="$DB_PASSWORD" "$MYSQL_BIN" \
    --host=127.0.0.1 \
    --port=3306 \
    --user="$DB_USERNAME" < "$INIT_SQL"

  echo "Database online_bookkeeping created."
else
  echo "Database online_bookkeeping already exists."
  echo "Existing users and bills will be preserved."
fi

SCHEMA_CHECK="$(
  MYSQL_PWD="$DB_PASSWORD" "$MYSQL_BIN" \
    --host=127.0.0.1 \
    --port=3306 \
    --user="$DB_USERNAME" \
    --batch \
    --skip-column-names \
    -e "
      SELECT COUNT(*)
      FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = 'online_bookkeeping'
        AND TABLE_NAME = 'users'
        AND COLUMN_NAME IN ('email', 'currency');
    "
)"

if [ "$SCHEMA_CHECK" != "2" ]; then
  finish_with_error "The database has an old structure. Recreate it with the current database/init.sql."
fi

if command -v lsof >/dev/null 2>&1; then
  if lsof -ti tcp:8080 >/dev/null 2>&1; then
    finish_with_error "Port 8080 is already in use."
  fi

  if lsof -ti tcp:5173 >/dev/null 2>&1; then
    finish_with_error "Port 5173 is already in use."
  fi
fi

print_step "Installing and building frontend"

cd "$FRONTEND_DIR"
npm install --no-audit --no-fund
npm run build

print_step "Building backend"

cd "$BACKEND_DIR"
chmod +x ./mvnw
./mvnw -DskipTests package

BACKEND_JAR="$(
  find "$BACKEND_DIR/target" \
    -maxdepth 1 \
    -type f \
    -name "*.jar" \
    ! -name "*.original" \
    | head -n 1
)"

if [ -z "$BACKEND_JAR" ]; then
  finish_with_error "Backend JAR file was not created."
fi

print_step "Starting backend"

cd "$BACKEND_DIR"
java -jar "$BACKEND_JAR" \
  > "$LOG_DIR/backend.log" \
  2>&1 &

BACKEND_PID=$!

BACKEND_READY=false

for _ in $(seq 1 60); do
  if curl -fsS "http://localhost:8080/api/health" >/dev/null 2>&1; then
    BACKEND_READY=true
    break
  fi

  if ! kill -0 "$BACKEND_PID" 2>/dev/null; then
    echo
    tail -n 50 "$LOG_DIR/backend.log" || true
    finish_with_error "Backend stopped during startup."
  fi

  sleep 1
done

if [ "$BACKEND_READY" != "true" ]; then
  echo
  tail -n 50 "$LOG_DIR/backend.log" || true
  finish_with_error "Backend did not become ready in 60 seconds."
fi

echo "Backend is available at http://localhost:8080"

print_step "Starting frontend"

cd "$FRONTEND_DIR"
npm run preview -- --host localhost --port 5173 \
  > "$LOG_DIR/frontend.log" \
  2>&1 &

FRONTEND_PID=$!

FRONTEND_READY=false

for _ in $(seq 1 30); do
  if curl -fsS "http://localhost:5173" >/dev/null 2>&1; then
    FRONTEND_READY=true
    break
  fi

  if ! kill -0 "$FRONTEND_PID" 2>/dev/null; then
    echo
    tail -n 50 "$LOG_DIR/frontend.log" || true
    finish_with_error "Frontend stopped during startup."
  fi

  sleep 1
done

if [ "$FRONTEND_READY" != "true" ]; then
  echo
  tail -n 50 "$LOG_DIR/frontend.log" || true
  finish_with_error "Frontend did not become ready."
fi

echo
echo "WalletWise is ready:"
echo "http://localhost:5173"
echo
echo "Keep this terminal window open while using the application."

open "http://localhost:5173"

echo
read -r -p "Press Enter to stop WalletWise..."