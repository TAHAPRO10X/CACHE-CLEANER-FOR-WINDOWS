@echo off
cls
echo.
echo ============================================================
echo                       Cash Cleaner V1.1
echo ============================================================
echo   https://github.com/TAHAPRO10X/CACHE-CLEANER-FOR-WINDOWS
echo ============================================================
echo.

:: Check for admin rights
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    color 0C
    echo [ERROR] Please run this script as Administrator.
    echo.
    pause
    exit /b 1
)

color 0B
echo [INFO] Starting Temp Cleaner...
echo.

:: Detect Windows version
set WIN_VER=
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%VERSION%" == "10.0" set WIN_VER=10
if "%VERSION%" == "6.3" set WIN_VER=8.1
if "%VERSION%" == "6.2" set WIN_VER=8
if "%VERSION%" == "6.1" set WIN_VER=7
if "%VERSION%" == "6.0" set WIN_VER=Vista
if "%VERSION%" == "5.1" set WIN_VER=XP

if "%WIN_VER%" == "" (
    for /f "tokens=2 delims== " %%a in ('wmic os get caption /value ^| find "="') do set OS_NAME=%%a
    set WIN_VER=Modern
)

echo [INFO] Detected Windows Version: %WIN_VER%
echo.

:: STEP 1: Clean C:\Windows\Temp
color 0A
echo [STEP 1] Cleaning C:\Windows\Temp...
if exist "C:\Windows\Temp\*.*" (
    del /f /q "C:\Windows\Temp\*.*" 2>nul
    for /d %%D in ("C:\Windows\Temp\*") do rd /s /q "%%D" 2>nul
)
echo [LOG] C:\Windows\Temp cleaned.
echo.

:: STEP 2: Clean Prefetch and User Temp
color 0E
echo [STEP 2] Cleaning Prefetch and User Temp directories...
if exist "%SystemRoot%\Prefetch\*.*" (
    del /f /q "%SystemRoot%\Prefetch\*.*" 2>nul
    for /d %%D in ("%SystemRoot%\Prefetch\*") do rd /s /q "%%D" 2>nul
)

if exist "%temp%\*.*" (
    del /f /q "%temp%\*.*" 2>nul
    for /d %%D in ("%temp%\*") do rd /s /q "%%D" 2>nul
)
echo [LOG] Prefetch and %temp% cleaned.
echo.

:: STEP 3: Clean legacy paths
color 0C
echo [STEP 3] Cleaning legacy temp paths...

set "LEGACY_PATHS=C:\Windows\Tempor~1 C:\Windows\Tmp C:\Windows\ff*.tmp C:\Windows\History C:\Windows\Cookies C:\Windows\Recent"

for %%P in (%LEGACY_PATHS%) do (
    if exist "%%P" (
        if exist "%%P\*" (
            del /f /q "%%P\*.*" 2>nul
            for /d %%D in ("%%P\*") do rd /s /q "%%D" 2>nul
        )
        if not "%%~xP" == "" (
            del /f /q "%%P" 2>nul
        ) else (
            rd /s /q "%%P" 2>nul
        )
    )
)

:: Clean print spooler
if exist "%SystemRoot%\System32\spool\PRINTERS\*.*" (
    del /f /q "%SystemRoot%\System32\spool\PRINTERS\*.*" 2>nul
    for /d %%D in ("%SystemRoot%\System32\spool\PRINTERS\*") do rd /s /q "%%D" 2>nul
)
echo [LOG] Legacy paths and print spooler cleaned.
echo.

:: STEP 4: Flush DNS
color 0D
echo [STEP 4] Flushing DNS Cache...
ipconfig /flushdns >nul 2>&1
echo [LOG] DNS Cache flushed.
echo.

:: Completion
color 0B
echo ============================================================
echo [INFO] ✅ Cleaning Completed Successfully!
echo ============================================================
echo.
pause
cls
exit /b 0
