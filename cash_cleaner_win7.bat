@echo off
title Cash Cleaner - win 7
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
echo ======================================================
echo                  CASH CLEANER v1.1
echo               Developer: Ahmed Hassan
echo      GitHub: https://github.com/ahmed-hassan-coder-x
echo ======================================================
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
echo [INFO] Cash Cleaner Started
echo.
timeout /t 1 >nul

color %yellow%
echo [STEP 1] Cleaning C:\Windows\Temp...
del /s /f /q C:\Windows\Temp\*.* 2>nul
for /d %%i in (C:\Windows\Temp\*) do rd /s /q "%%i" 2>nul
color %green%
echo [OK] C:\Windows\Temp cleaned.
echo.
timeout /t 1 >nul

color %yellow%
echo [STEP 2] Cleaning Prefetch and user temp...
del /s /f /q C:\Windows\Prefetch\*.* 2>nul
for /d %%i in (C:\Windows\Prefetch\*) do rd /s /q "%%i" 2>nul
del /s /f /q "%temp%\*.*" 2>nul
for /d %%i in (%temp%\*) do rd /s /q "%%i" 2>nul
color %green%
echo [OK] Prefetch and %temp% cleaned.
echo.
timeout /t 1 >nul

color %yellow%
echo [STEP 3] Removing legacy temp directories...
rd /s /q "C:\Windows\Tempor~1"   2>nul
rd /s /q "C:\Windows\Tmp"        2>nul
del /s /f /q "C:\Windows\ff*.tmp" 2>nul
rd /s /q "C:\Windows\History"    2>nul
rd /s /q "C:\Windows\Cookies"    2>nul
rd /s /q "C:\Windows\Recent"     2>nul
rd /s /q "C:\Windows\Spool\Printers" 2>nul
color %green%
echo [OK] Legacy directories cleaned.
echo.
timeout /t 1 >nul

color %blue%
echo [INFO] Cash Cleaner Completed Successfully!
echo.
color %white%

cls