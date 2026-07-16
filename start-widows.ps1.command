$ErrorActionPreference = "Stop"

$RootDirectory = $PSScriptRoot
$BackendDirectory = Join-Path $RootDirectory "backend"
$FrontendDirectory = Join-Path $RootDirectory "frontend"
$DatabaseDirectory = Join-Path $RootDirectory "database"
$LogDirectory = Join-Path $RootDirectory "logs"

$ConfigFile = Join-Path $BackendDirectory "src\main\resources\application-local.properties"
$InitSql = Join-Path $DatabaseDirectory "init.sql"

$BackendProcess = $null
$FrontendProcess = $null

function Write-Step {
    param([string]$Message)

    Write-Host ""
    Write-Host "============================================================"
    Write-Host $Message
    Write-Host "============================================================"
}

function Get-PropertyValue {
    param(
        [string]$Path,
        [string]$Name
    )

    $Prefix = "$Name="

    foreach ($Line in Get-Content -LiteralPath $Path) {
        if ($Line.StartsWith($Prefix)) {
            return $Line.Substring($Prefix.Length)
        }
    }

    return $null
}

function New-Base64Secret {
    $Bytes = New-Object byte[] 32
    $Generator = [System.Security.Cryptography.RandomNumberGenerator]::Create()

    try {
        $Generator.GetBytes($Bytes)
    }
    finally {
        $Generator.Dispose()
    }

    return [Convert]::ToBase64String($Bytes)
}

function New-LocalConfiguration {
    Write-Step "First-time local configuration"

    Write-Host "The MySQL password will be stored only on this computer."
    Write-Host "The local configuration file is excluded from Git."
    Write-Host ""

    $DatabaseUsername = Read-Host "MySQL username [root]"

    if ([string]::IsNullOrWhiteSpace($DatabaseUsername)) {
        $DatabaseUsername = "root"
    }

    $SecurePassword = Read-Host "MySQL password" -AsSecureString
    $Pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)

    try {
        $DatabasePassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($Pointer)
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Pointer)
    }

    if ([string]::IsNullOrEmpty($DatabasePassword)) {
        throw "MySQL password cannot be empty."
    }

    $JwtSecret = New-Base64Secret

    $Lines = @(
        "spring.datasource.url=jdbc:mysql://localhost:3306/online_bookkeeping?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true"
        "spring.datasource.username=$DatabaseUsername"
        "spring.datasource.password=$DatabasePassword"
        "spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver"
        ""
        "jwt.secret=$JwtSecret"
    )

    $Utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllLines($ConfigFile, $Lines, $Utf8WithoutBom)

    Write-Host ""
    Write-Host "Local configuration created:"
    Write-Host $ConfigFile
}

function Find-MySql {
    $Command = Get-Command "mysql.exe" -ErrorAction SilentlyContinue

    if ($null -ne $Command) {
        return $Command.Source
    }

    $Candidates = @(
        "C:\Program Files\MySQL\MySQL Server 9.0\bin\mysql.exe"
        "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
        "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
        "C:\xampp\mysql\bin\mysql.exe"
    )

    foreach ($Candidate in $Candidates) {
        if (Test-Path -LiteralPath $Candidate) {
            return $Candidate
        }
    }

    if (Test-Path -LiteralPath "C:\Program Files\MySQL") {
        $FoundFile = Get-ChildItem `
            -Path "C:\Program Files\MySQL" `
            -Filter "mysql.exe" `
            -File `
            -Recurse `
            -ErrorAction SilentlyContinue |
            Select-Object -First 1

        if ($null -ne $FoundFile) {
            return $FoundFile.FullName
        }
    }

    return $null
}

function Wait-ForUrl {
    param(
        [string]$Url,
        [int]$Attempts
    )

    for ($Attempt = 1; $Attempt -le $Attempts; $Attempt++) {
        try {
            Invoke-WebRequest `
                -Uri $Url `
                -UseBasicParsing `
                -TimeoutSec 2 |
                Out-Null

            return $true
        }
        catch {
            Start-Sleep -Seconds 1
        }
    }

    return $false
}

function Stop-ProcessTree {
    param([System.Diagnostics.Process]$Process)

    if ($null -eq $Process) {
        return
    }

    try {
        if (!$Process.HasExited) {
            & taskkill.exe /PID $Process.Id /T /F 2>$null | Out-Null
        }
    }
    catch {
        # The process may already have stopped.
    }
}

try {
    New-Item -ItemType Directory -Force -Path $LogDirectory | Out-Null

    if (!(Test-Path -LiteralPath $BackendDirectory) -or
        !(Test-Path -LiteralPath $FrontendDirectory) -or
        !(Test-Path -LiteralPath $InitSql)) {
        throw "Required project directories were not found."
    }

    if (!(Test-Path -LiteralPath $ConfigFile)) {
        New-LocalConfiguration
    }

    $DatabaseUsername = Get-PropertyValue `
        -Path $ConfigFile `
        -Name "spring.datasource.username"

    $DatabasePassword = Get-PropertyValue `
        -Path $ConfigFile `
        -Name "spring.datasource.password"

    if ([string]::IsNullOrWhiteSpace($DatabaseUsername)) {
        throw "spring.datasource.username is missing in application-local.properties."
    }

    if ([string]::IsNullOrEmpty($DatabasePassword) -or
        $DatabasePassword -eq "YOUR_MYSQL_PASSWORD" -or
        $DatabasePassword -eq "YOUR_PASSWORD") {
        throw "Set a real MySQL password in application-local.properties."
    }

    Write-Step "Checking required software"

    if ($null -eq (Get-Command "java.exe" -ErrorAction SilentlyContinue)) {
        throw "Java 17 is not installed or is not available in PATH."
    }

    if ($null -eq (Get-Command "node.exe" -ErrorAction SilentlyContinue)) {
        throw "Node.js is not installed or is not available in PATH."
    }

    if ($null -eq (Get-Command "npm.cmd" -ErrorAction SilentlyContinue)) {
        throw "npm is not installed or is not available in PATH."
    }

    $MySqlExecutable = Find-MySql

    if ([string]::IsNullOrWhiteSpace($MySqlExecutable)) {
        throw "MySQL command-line client mysql.exe was not found."
    }

    Write-Host "Java:"
    & java.exe -version

    Write-Host "Node.js: $(& node.exe --version)"
    Write-Host "npm: $(& npm.cmd --version)"
    Write-Host "MySQL client: $MySqlExecutable"

    Write-Step "Checking MySQL"

    $env:MYSQL_PWD = $DatabasePassword

    & $MySqlExecutable `
        "--host=127.0.0.1" `
        "--port=3306" `
        "--user=$DatabaseUsername" `
        "--batch" `
        "--skip-column-names" `
        "-e" `
        "SELECT 1;" |
        Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "Cannot connect to MySQL. Start MySQL and check the local password."
    }

    $DatabaseExists = & $MySqlExecutable `
        "--host=127.0.0.1" `
        "--port=3306" `
        "--user=$DatabaseUsername" `
        "--batch" `
        "--skip-column-names" `
        "-e" `
        "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'online_bookkeeping';"

    if ($DatabaseExists -notcontains "online_bookkeeping") {
        Write-Host "Database not found. Running database\init.sql..."

        $InitProcess = Start-Process `
            -FilePath $MySqlExecutable `
            -ArgumentList @(
                "--host=127.0.0.1",
                "--port=3306",
                "--user=$DatabaseUsername"
            ) `
            -RedirectStandardInput $InitSql `
            -Wait `
            -NoNewWindow `
            -PassThru

        if ($InitProcess.ExitCode -ne 0) {
            throw "database\init.sql could not be executed."
        }

        Write-Host "Database online_bookkeeping created."
    }
    else {
        Write-Host "Database online_bookkeeping already exists."
        Write-Host "Existing users and bills will be preserved."
    }

    $SchemaCheck = & $MySqlExecutable `
        "--host=127.0.0.1" `
        "--port=3306" `
        "--user=$DatabaseUsername" `
        "--batch" `
        "--skip-column-names" `
        "-e" `
        "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'online_bookkeeping' AND TABLE_NAME = 'users' AND COLUMN_NAME IN ('email', 'currency');"

    if (($SchemaCheck | Select-Object -First 1).Trim() -ne "2") {
        throw "The database has an old structure. Recreate it with the current database\init.sql."
    }

    $Port8080 = Get-NetTCPConnection `
        -LocalPort 8080 `
        -State Listen `
        -ErrorAction SilentlyContinue

    if ($null -ne $Port8080) {
        throw "Port 8080 is already in use."
    }

    $Port5173 = Get-NetTCPConnection `
        -LocalPort 5173 `
        -State Listen `
        -ErrorAction SilentlyContinue

    if ($null -ne $Port5173) {
        throw "Port 5173 is already in use."
    }

    Write-Step "Installing and building frontend"

    Push-Location $FrontendDirectory

    try {
        & npm.cmd install --no-audit --no-fund

        if ($LASTEXITCODE -ne 0) {
            throw "npm install failed."
        }

        & npm.cmd run build

        if ($LASTEXITCODE -ne 0) {
            throw "Frontend build failed."
        }
    }
    finally {
        Pop-Location
    }

    Write-Step "Building backend"

    Push-Location $BackendDirectory

    try {
        & ".\mvnw.cmd" "-DskipTests" "package"

        if ($LASTEXITCODE -ne 0) {
            throw "Backend build failed."
        }
    }
    finally {
        Pop-Location
    }

    $BackendJar = Get-ChildItem `
        -Path (Join-Path $BackendDirectory "target") `
        -Filter "*.jar" `
        -File |
        Where-Object { $_.Name -notlike "*.original" } |
        Select-Object -First 1

    if ($null -eq $BackendJar) {
        throw "Backend JAR file was not created."
    }

    Write-Step "Starting backend"

    $BackendLog = Join-Path $LogDirectory "backend.log"
    $BackendErrorLog = Join-Path $LogDirectory "backend-error.log"

    $BackendProcess = Start-Process `
        -FilePath "java.exe" `
        -ArgumentList "-jar `"$($BackendJar.FullName)`"" `
        -WorkingDirectory $BackendDirectory `
        -RedirectStandardOutput $BackendLog `
        -RedirectStandardError $BackendErrorLog `
        -PassThru

    if (!(Wait-ForUrl -Url "http://localhost:8080/api/health" -Attempts 60)) {
        if (Test-Path -LiteralPath $BackendLog) {
            Get-Content -LiteralPath $BackendLog -Tail 50
        }

        if (Test-Path -LiteralPath $BackendErrorLog) {
            Get-Content -LiteralPath $BackendErrorLog -Tail 50
        }

        throw "Backend did not become ready in 60 seconds."
    }

    Write-Host "Backend is available at http://localhost:8080"

    Write-Step "Starting frontend"

    $FrontendLog = Join-Path $LogDirectory "frontend.log"
    $FrontendErrorLog = Join-Path $LogDirectory "frontend-error.log"

    $FrontendProcess = Start-Process `
        -FilePath "npm.cmd" `
        -ArgumentList @(
            "run",
            "preview",
            "--",
            "--host",
            "localhost",
            "--port",
            "5173"
        ) `
        -WorkingDirectory $FrontendDirectory `
        -RedirectStandardOutput $FrontendLog `
        -RedirectStandardError $FrontendErrorLog `
        -PassThru

    if (!(Wait-ForUrl -Url "http://localhost:5173" -Attempts 30)) {
        if (Test-Path -LiteralPath $FrontendLog) {
            Get-Content -LiteralPath $FrontendLog -Tail 50
        }

        if (Test-Path -LiteralPath $FrontendErrorLog) {
            Get-Content -LiteralPath $FrontendErrorLog -Tail 50
        }

        throw "Frontend did not become ready."
    }

    Write-Host ""
    Write-Host "WalletWise is ready:"
    Write-Host "http://localhost:5173"
    Write-Host ""
    Write-Host "Keep this window open while using the application."

    Start-Process "http://localhost:5173"

    Write-Host ""
    Read-Host "Press Enter to stop WalletWise"
}
catch {
    Write-Host ""
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to close"
    exit 1
}
finally {
    Stop-ProcessTree -Process $FrontendProcess
    Stop-ProcessTree -Process $BackendProcess

    $env:MYSQL_PWD = $null
}