#!/bin/bash

set -u

PROJECT_ROOT="$(
  cd "$(dirname "$0")" &&
  pwd
)"

BACKEND_DIR="$PROJECT_ROOT/backend"
FRONTEND_DIR="$PROJECT_ROOT/frontend"
DATABASE_DIR="$PROJECT_ROOT/database"

BACKEND_CONFIG="$BACKEND_DIR/src/main/resources/application-local.properties"
BACKEND_JAR="$BACKEND_DIR/target/backend-0.0.1-SNAPSHOT.jar"
INIT_SQL="$DATABASE_DIR/init.sql"

RUN_DIR="/tmp/walletwise-run"
BACKEND_LOG="$RUN_DIR/backend.log"
FRONTEND_LOG="$RUN_DIR/frontend.log"

BACKEND_PID=""
FRONTEND_PID=""

function pause_before_exit() {
  echo
  read -r -p "Press Enter to close this window..."
}

function fail() {
  echo
  echo "ERROR: $1"
  echo

  pause_before_exit
  exit 1
}

function cleanup() {
  if [ -n "$FRONTEND_PID" ]; then
    kill "$FRONTEND_PID" \
      2>/dev/null || true
  fi

  if [ -n "$BACKEND_PID" ]; then
    kill "$BACKEND_PID" \
      2>/dev/null || true
  fi

  if [ -n "$FRONTEND_PID" ]; then
    wait "$FRONTEND_PID" \
      2>/dev/null || true
  fi

  if [ -n "$BACKEND_PID" ]; then
    wait "$BACKEND_PID" \
      2>/dev/null || true
  fi
}

trap cleanup EXIT
trap 'exit 130' INT TERM

mkdir -p "$RUN_DIR"

echo
echo "======================================"
echo "         WalletWise Launcher"
echo "======================================"
echo

command -v java >/dev/null 2>&1 ||
  fail "Java is not installed."

command -v node >/dev/null 2>&1 ||
  fail "Node.js is not installed."

command -v npm >/dev/null 2>&1 ||
  fail "npm is not installed."

command -v curl >/dev/null 2>&1 ||
  fail "curl is not available."

command -v nc >/dev/null 2>&1 ||
  fail "The nc command is not available."

if [ ! -f "$BACKEND_CONFIG" ]; then
  fail "application-local.properties was not found."
fi

if [ ! -f "$INIT_SQL" ]; then
  fail "database/init.sql was not found."
fi

if grep -Eq \
  "YOUR_PASSWORD|YOUR_MYSQL_PASSWORD|GENERATE_WITH_OPENSSL|YOUR_GENERATED_JWT_SECRET" \
  "$BACKEND_CONFIG"; then

  fail "Replace placeholders in application-local.properties."
fi

DB_USERNAME="$(
  sed -n \
    's/^spring.datasource.username=//p' \
    "$BACKEND_CONFIG" |
  tail -n 1 |
  tr -d '\r'
)"

DB_PASSWORD="$(
  sed -n \
    's/^spring.datasource.password=//p' \
    "$BACKEND_CONFIG" |
  tail -n 1 |
  tr -d '\r'
)"

if [ -z "$DB_USERNAME" ]; then
  fail "Database username is missing in application-local.properties."
fi

if [ -z "$DB_PASSWORD" ]; then
  fail "Database password is missing in application-local.properties."
fi

MYSQL_COMMAND="$(
  command -v mysql 2>/dev/null ||
  true
)"

if [ -z "$MYSQL_COMMAND" ]; then
  for candidate in \
    "/usr/local/mysql/bin/mysql" \
    "/opt/homebrew/bin/mysql" \
    "/usr/local/bin/mysql"
  do
    if [ -x "$candidate" ]; then
      MYSQL_COMMAND="$candidate"
      break
    fi
  done
fi

if [ -z "$MYSQL_COMMAND" ]; then
  fail "MySQL command-line client was not found."
fi

echo "Checking MySQL server..."

if ! nc -z \
  127.0.0.1 \
  3306 \
  >/dev/null 2>&1; then

  fail "MySQL is not running. Start it in macOS settings."
fi

if ! MYSQL_PWD="$DB_PASSWORD" \
  "$MYSQL_COMMAND" \
  --host=127.0.0.1 \
  --port=3306 \
  --user="$DB_USERNAME" \
  --execute="SELECT 1;" \
  >/dev/null 2>&1; then

  fail "Cannot connect to MySQL. Check the username and password."
fi

echo "MySQL connection successful."

DATABASE_EXISTS="$(
  MYSQL_PWD="$DB_PASSWORD" \
  "$MYSQL_COMMAND" \
  --host=127.0.0.1 \
  --port=3306 \
  --user="$DB_USERNAME" \
  --batch \
  --skip-column-names \
  --execute="
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.SCHEMATA
    WHERE SCHEMA_NAME = 'online_bookkeeping';
  "
)"

if [ "$DATABASE_EXISTS" = "0" ]; then
  echo
  echo "Database does not exist."
  echo "Creating clean online_bookkeeping database..."

  if ! MYSQL_PWD="$DB_PASSWORD" \
    "$MYSQL_COMMAND" \
    --host=127.0.0.1 \
    --port=3306 \
    --user="$DB_USERNAME" \
    < "$INIT_SQL"; then

    fail "Database initialization failed."
  fi

  echo "Database created successfully."
else
  echo "Database already exists. Existing data will be preserved."
fi

TABLE_COUNT="$(
  MYSQL_PWD="$DB_PASSWORD" \
  "$MYSQL_COMMAND" \
  --host=127.0.0.1 \
  --port=3306 \
  --user="$DB_USERNAME" \
  --batch \
  --skip-column-names \
  --execute="
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'online_bookkeeping'
      AND TABLE_NAME IN ('users', 'bills');
  "
)"

if [ "$TABLE_COUNT" != "2" ]; then
  fail "Database exists, but required tables are missing."
fi

PROFILE_COLUMN_COUNT="$(
  MYSQL_PWD="$DB_PASSWORD" \
  "$MYSQL_COMMAND" \
  --host=127.0.0.1 \
  --port=3306 \
  --user="$DB_USERNAME" \
  --batch \
  --skip-column-names \
  --execute="
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'online_bookkeeping'
      AND TABLE_NAME = 'users'
      AND COLUMN_NAME IN ('email', 'currency');
  "
)"

if [ "$PROFILE_COLUMN_COUNT" != "2" ]; then
  fail "The users table has an outdated structure. Reset the database."
fi

echo "Database structure verified."

if lsof -tiTCP:8080 \
  -sTCP:LISTEN \
  >/dev/null 2>&1; then

  fail "Port 8080 is already in use."
fi

if lsof -tiTCP:5173 \
  -sTCP:LISTEN \
  >/dev/null 2>&1; then

  fail "Port 5173 is already in use."
fi

echo
echo "Installing frontend dependencies..."

cd "$FRONTEND_DIR" ||
  fail "Frontend directory was not found."

npm install \
  --no-audit \
  --no-fund ||
  fail "Frontend dependency installation failed."

echo
echo "Building frontend..."

npm run build ||
  fail "Frontend build failed."

echo
echo "Building backend..."

cd "$BACKEND_DIR" ||
  fail "Backend directory was not found."

chmod +x "$BACKEND_DIR/mvnw"

./mvnw \
  -DskipTests \
  package ||
  fail "Backend build failed."

if [ ! -f "$BACKEND_JAR" ]; then
  fail "Backend JAR file was not created."
fi

echo
echo "Starting backend..."

java -jar "$BACKEND_JAR" \
  >"$BACKEND_LOG" 2>&1 &

BACKEND_PID=$!

BACKEND_READY=false

for attempt in $(seq 1 60); do
  if curl -fsS \
    "http://localhost:8080/api/health" \
    >/dev/null 2>&1; then

    BACKEND_READY=true
    break
  fi

  if ! kill -0 \
    "$BACKEND_PID" \
    2>/dev/null; then

    echo
    echo "Backend stopped unexpectedly."
    echo
    tail -n 50 "$BACKEND_LOG"

    fail "Backend startup failed."
  fi

  sleep 1
done

if [ "$BACKEND_READY" != true ]; then
  echo
  tail -n 50 "$BACKEND_LOG"

  fail "Backend did not start within 60 seconds."
fi

echo "Backend started:"
echo "http://localhost:8080"

echo
echo "Starting frontend..."

cd "$FRONTEND_DIR" ||
  fail "Frontend directory was not found."

npm run preview -- \
  --host 127.0.0.1 \
  --port 5173 \
  >"$FRONTEND_LOG" 2>&1 &

FRONTEND_PID=$!

FRONTEND_READY=false

for attempt in $(seq 1 30); do
  if curl -fsS \
    "http://localhost:5173" \
    >/dev/null 2>&1; then

    FRONTEND_READY=true
    break
  fi

  if ! kill -0 \
    "$FRONTEND_PID" \
    2>/dev/null; then

    echo
    echo "Frontend stopped unexpectedly."
    echo
    tail -n 50 "$FRONTEND_LOG"

    fail "Frontend startup failed."
  fi

  sleep 1
done

if [ "$FRONTEND_READY" != true ]; then
  echo
  tail -n 50 "$FRONTEND_LOG"

  fail "Frontend did not start within 30 seconds."
fi

echo "Frontend started:"
echo "http://localhost:5173"

echo
echo "======================================"
echo " WalletWise started successfully"
echo "======================================"
echo
echo "Website:"
echo "http://localhost:5173"
echo
echo "Backend:"
echo "http://localhost:8080"
echo
echo "Backend log:"
echo "$BACKEND_LOG"
echo
echo "Frontend log:"
echo "$FRONTEND_LOG"
echo
echo "Press Control+C to stop WalletWise."
echo

open "http://localhost:5173"

wait