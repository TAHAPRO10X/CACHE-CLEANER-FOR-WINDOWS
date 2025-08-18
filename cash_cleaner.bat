@echo off
echo ==============================
echo ░██░ ░██░ ░███ █░█    ░██░ █░░ ███ ░██░ █░░░█ ███ ███░  
echo █░░█ █░░█ █░░░ █░█    █░░█ █░░ █░░ █░░█ ██░░█ █░░ █░░█  
echo █░░░ ████ ░██░ ███    █░░░ █░░ ███ ████ █░█░█ ███ ███░  
echo █░░█ █░░█ ░░░█ █░█    █░░█ █░░ █░░ █░░█ █░░██ █░░ █░░█  
echo ░██░ █░░█ ███░ █░█    ░██░ ███ ███ █░░█ █░░░█ ███ █░░█  
echo ==============================

:: Set color for logs
color 0B
echo.
echo [INFO] Temp Cleaner Started
echo.

:: Step 1: Clean C:\Windows\Temp
color 0A
echo [STEP 1] Cleaning C:\Windows\Temp...
del /s /f /q C:\Windows\Temp\*.*
if exist C:\Windows\Temp (
    rd /s /q C:\Windows\Temp
    md C:\Windows\Temp
)
echo [LOG] C:\Windows\Temp cleaned.
echo.

:: Step 2: Clean Prefetch and user temp
color 0E
echo [STEP 2] Cleaning Prefetch and user temp directories...
del /s /f /q C:\WINDOWS\Prefetch
del /s /f /q %temp%\*.*
rd /s /q %temp%
md %temp%
echo [LOG] Prefetch and %temp% cleaned.
echo.

:: Step 3: Remove legacy temp directories
color 0C
echo [STEP 3] Removing legacy temp directories...
deltree /y C:\Windows\Tempor~1
deltree /y C:\Windows\Temp
deltree /y C:\Windows\Tmp
deltree /y C:\Windows\ff*.tmp
deltree /y C:\Windows\Prefetch
deltree /y C:\Windows\History
deltree /y C:\Windows\Cookies
deltree /y C:\Windows\Recent
deltree /y C:\Windows\Spool\Printers
echo [LOG] Legacy directories cleaned.
echo.

:: Final log
color 0B
echo [INFO] Temp Cleaner Completed Successfully!
echo.
cls


