@echo off
title Cash Cleaner - win 10
mode con: cols=120 lines=40

:: Define colors
set "green=0A"
set "yellow=0E"
set "red=0C"
set "blue=09"
set "white=07"

:menu
cls
color %green%
echo ==================================================================
echo                  CASH CLEANER v1.0
echo          Developer: Ahmed Hassan & TAHAPRO10X
echo   GitHub: https://github.com/TAHAPRO10X/CACHE-CLEANER-FOR-WINDOWS
echo ==================================================================
echo.
color %white%
echo   [1] Run Cleaner
echo   [2] Exit
echo.
set /p choice="Select option: "

if "%choice%"=="1" goto run
if "%choice%"=="2" exit
goto menu

:run
cls
color %blue%
echo.
echo [INFO] Temp Cleaner Started
echo.

:: Step 1: Clean C:\Windows\Temp
color %yellow%
echo [STEP 1] Cleaning C:\Windows\Temp...
del /s /f /q C:\Windows\Temp\*.*
if exist C:\Windows\Temp (
    rd /s /q C:\Windows\Temp
    md C:\Windows\Temp
)
color %green%
echo [LOG] C:\Windows\Temp cleaned.
echo.

:: Step 2: Clean Prefetch and user temp
color %yellow%
echo [STEP 2] Cleaning Prefetch and user temp directories...
del /s /f /q C:\WINDOWS\Prefetch
del /s /f /q %temp%\*.*
rd /s /q %temp%
md %temp%
color %green%
echo [LOG] Prefetch and %temp% cleaned.
echo.

:: Step 3: Remove legacy temp directories
color %yellow%
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
color %green%
echo [LOG] Legacy directories cleaned.
echo.

:: Final log
color %blue%
echo [INFO] Temp Cleaner Completed Successfully!
echo.
color %white%

cls

