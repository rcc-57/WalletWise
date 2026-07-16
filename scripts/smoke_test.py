#!/usr/bin/env python3

import json
import os
import time
import urllib.error
import urllib.request
from decimal import Decimal


BASE_URL = os.getenv(
    "WALLETWISE_BASE_URL",
    "http://localhost:8080"
)


def request(
    method,
    path,
    expected_status,
    data=None,
    token=None
):
    headers = {
        "Accept": "application/json"
    }

    body = None

    if data is not None:
        headers["Content-Type"] = "application/json"
        body = json.dumps(data).encode("utf-8")

    if token is not None:
        headers["Authorization"] = f"Bearer {token}"

    http_request = urllib.request.Request(
        url=BASE_URL + path,
        data=body,
        headers=headers,
        method=method
    )

    try:
        with urllib.request.urlopen(
            http_request
        ) as response:
            status = response.status
            response_body = (
                response.read().decode("utf-8")
            )
    except urllib.error.HTTPError as error:
        status = error.code
        response_body = (
            error.read().decode("utf-8")
        )

    if status != expected_status:
        raise AssertionError(
            f"{method} {path}: "
            f"expected {expected_status}, "
            f"got {status}. "
            f"Response: {response_body}"
        )

    if not response_body:
        return None

    return json.loads(response_body)


def check(condition, message):
    if not condition:
        raise AssertionError(message)


def main():
    unique_suffix = str(time.time_ns())

    username_a = f"smoke_a_{unique_suffix}"
    username_b = f"smoke_b_{unique_suffix}"
    email_a = f"{username_a}@example.com"

    password = "SmokeTest123!"

    print("1. Registering user A")

    auth_a = request(
        "POST",
        "/api/auth/register",
        201,
        {
            "username": username_a,
            "password": password,
            "currency": "USD"
        }
    )

    token_a = auth_a["token"]

    check(
        auth_a["user"]["currency"] == "USD",
        "Registration currency was not saved"
    )

    check(
        auth_a["user"]["email"] is None,
        "New user email must initially be empty"
    )

    print("2. Registering user B")

    auth_b = request(
        "POST",
        "/api/auth/register",
        201,
        {
            "username": username_b,
            "password": password,
            "currency": "EUR"
        }
    )

    token_b = auth_b["token"]

    print("3. Checking current user")

    current_user = request(
        "GET",
        "/api/auth/me",
        200,
        token=token_a
    )

    check(
        current_user["username"] == username_a,
        "Current user does not match token owner"
    )

    check(
        current_user["currency"] == "USD",
        "Current user has incorrect currency"
    )

    print("4. Updating profile")

    updated_profile = request(
        "PUT",
        "/api/auth/me",
        200,
        {
            "email": email_a,
            "currency": "CNY"
        },
        token_a
    )

    check(
        updated_profile["email"] == email_a,
        "Profile email was not updated"
    )

    check(
        updated_profile["currency"] == "CNY",
        "Profile currency was not updated"
    )

    print("5. Checking persisted profile")

    persisted_profile = request(
        "GET",
        "/api/auth/me",
        200,
        token=token_a
    )

    check(
        persisted_profile["email"] == email_a,
        "Profile email was not persisted"
    )

    check(
        persisted_profile["currency"] == "CNY",
        "Profile currency was not persisted"
    )

    print("6. Checking request without JWT")

    request(
        "GET",
        "/api/auth/me",
        401
    )

    print("7. Checking duplicate username")

    request(
        "POST",
        "/api/auth/register",
        409,
        {
            "username": username_a,
            "password": password,
            "currency": "USD"
        }
    )

    print("8. Checking duplicate email")

    request(
        "PUT",
        "/api/auth/me",
        409,
        {
            "email": email_a,
            "currency": "EUR"
        },
        token_b
    )

    print("9. Checking invalid password")

    request(
        "POST",
        "/api/auth/login",
        401,
        {
            "username": username_a,
            "password": "WrongPassword!"
        }
    )

    print("10. Creating an expense")

    expense = request(
        "POST",
        "/api/bills",
        201,
        {
            "type": "EXPENSE",
            "category": "FOOD",
            "amount": 125.50,
            "billDate": "2026-07-13",
            "remark": "Smoke-test expense"
        },
        token_a
    )

    expense_id = expense["id"]

    print("11. Creating an income")

    request(
        "POST",
        "/api/bills",
        201,
        {
            "type": "INCOME",
            "category": "SALARY",
            "amount": 1000.00,
            "billDate": "2026-07-12",
            "remark": "Smoke-test income"
        },
        token_a
    )

    print("12. Checking bill filtering")

    expenses = request(
        "GET",
        "/api/bills?type=EXPENSE",
        200,
        token=token_a
    )

    check(
        len(expenses) == 1,
        "Expense filter returned unexpected data"
    )

    print("13. Checking user-data isolation")

    request(
        "GET",
        f"/api/bills/{expense_id}",
        404,
        token=token_b
    )

    print("14. Checking monthly statistics")

    statistics = request(
        "GET",
        (
            "/api/statistics/monthly"
            "?year=2026&month=7"
        ),
        200,
        token=token_a
    )

    check(
        Decimal(str(statistics["totalIncome"]))
        == Decimal("1000.00"),
        "Incorrect total income"
    )

    check(
        Decimal(str(statistics["totalExpense"]))
        == Decimal("125.50"),
        "Incorrect total expense"
    )

    check(
        Decimal(str(statistics["balance"]))
        == Decimal("874.50"),
        "Incorrect balance"
    )

    print("15. Updating the expense")

    updated_expense = request(
        "PUT",
        f"/api/bills/{expense_id}",
        200,
        {
            "type": "EXPENSE",
            "category": "FOOD",
            "amount": 150.00,
            "billDate": "2026-07-13",
            "remark": "Updated smoke-test expense"
        },
        token_a
    )

    check(
        Decimal(str(updated_expense["amount"]))
        == Decimal("150.00"),
        "Bill amount was not updated"
    )

    print("16. Checking invalid amount")

    request(
        "POST",
        "/api/bills",
        400,
        {
            "type": "EXPENSE",
            "category": "FOOD",
            "amount": 0,
            "billDate": "2026-07-13",
            "remark": "Invalid amount"
        },
        token_a
    )

    print("17. Deleting the expense")

    request(
        "DELETE",
        f"/api/bills/{expense_id}",
        204,
        token=token_a
    )

    print("18. Checking repeated deletion")

    request(
        "DELETE",
        f"/api/bills/{expense_id}",
        404,
        token=token_a
    )

    print()
    print(
        "All WalletWise backend smoke tests passed."
    )


if __name__ == "__main__":
    main()