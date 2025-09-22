@echo off
setlocal enabledelayedexpansion
cls
echo.
echo    ██████╗ ██╗   ██╗███████╗██████╗ ███████╗
echo    ██╔══██╗██║   ██║██╔════╝██╔══██╗██╔════╝
echo    ██████╔╝██║   ██║█████╗  ██████╔╝███████╗
echo    ██╔═══╝ ██║   ██║██╔══╝  ██╔══██╗╚════██║
echo    ██║     ╚██████╔╝███████╗██║  ██║███████║
echo    ╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝
echo.
echo  Cash Cleaner V3.0 - Ultimate Edition
echo  https://github.com/TAHAPRO10X/CACHE-CLEANER-FOR-WINDOWS
echo  Developer: https://github.com/ahmed-hassan-coder-x
echo  Security-Enhanced | Multi-Threaded | Modern OS Support
echo.
echo [1] Full System Cleanup (Recommended)
echo [2] Windows Temp & System Files
echo [3] User Temp & Browser Caches
echo [4] Windows Update & Store Cache
echo [5] DNS & Network Reset
echo [6] Recycle Bin & Thumbnail Cache
echo [7] Legacy System Cleanup
echo [8] Advanced System Optimization
echo [0] Exit
echo.

:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0C
    echo [ERROR] Administrator privileges required!
    echo Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

:: Create log file
set "log_file=%TEMP%\CashCleaner_Log_%DATE:/=-%_%TIME::=-%.log"
echo [LOG] Cash Cleaner V3.0 - Started %DATE% %TIME% > "%log_file%"

:menu
set choice=
set /p choice="Select an option (0-8): "

if "%choice%"=="0" goto exit
if "%choice%"=="1" goto full_clean
if "%choice%"=="2" goto step_temp
if "%choice%"=="3" goto step_browser
if "%choice%"=="4" goto step_update
if "%choice%"=="5" goto step_dns
if "%choice%"=="6" goto step_recycle
if "%choice%"=="7" goto step_legacy
if "%choice%"=="8" goto step_advanced
if "%choice%"=="" goto menu
if not defined choice goto menu

:full_clean
call :log "Starting Full System Cleanup..."
call :step_temp
call :step_browser
call :step_update
call :step_dns
call :step_recycle
call :step_legacy
call :step_advanced
goto end

:step_temp
call :log "Cleaning Windows System Temp Files..."
powershell -Command "Get-ChildItem -Path 'C:\Windows\Temp', 'C:\Windows\Prefetch' -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
call :log "Windows Temp cleaned successfully"

call :log "Cleaning System Cache Files..."
powershell -Command "Get-ChildItem -Path '%SystemRoot%\SoftwareDistribution\Download', '%SystemRoot%\System32\config\systemprofile\AppData\Local\Temp' -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
call :log "System cache cleaned successfully"
goto :eof

:step_browser
call :log "Cleaning Browser Caches..."
:: Chrome
if exist "%LocalAppData%\Google\Chrome\User Data\Default\Cache" (
    powershell -Command "Remove-Item -Path '%LocalAppData%\Google\Chrome\User Data\Default\Cache\*' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
)
:: Edge
if exist "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache" (
    powershell -Command "Remove-Item -Path '%LocalAppData%\Microsoft\Edge\User Data\Default\Cache\*' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
)
:: Firefox
if exist "%LocalAppData%\Mozilla\Firefox\Profiles" (
    for /d %%d in ("%LocalAppData%\Mozilla\Firefox\Profiles\*") do (
        if exist "%%d\cache2" (
            powershell -Command "Remove-Item -Path '%%d\cache2\*' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
        )
    )
)
:: Opera
if exist "%AppData%\Opera Software\Opera Stable\Cache" (
    powershell -Command "Remove-Item -Path '%AppData%\Opera Software\Opera Stable\Cache\*' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
)
call :log "Browser caches cleaned successfully"
goto :eof

:step_update
call :log "Cleaning Windows Update Cache..."
net stop wuauserv /y >nul 2>&1
powershell -Command "Remove-Item -Path '%SystemRoot%\SoftwareDistribution\Download\*' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
net start wuauserv >nul 2>&1
call :log "Windows Update cache cleaned"

call :log "Cleaning Windows Store Cache..."
WSReset.exe >nul 2>&1
call :log "Windows Store cache cleaned"
goto :eof

:step_dns
call :log "Flushing DNS Cache..."
ipconfig /flushdns >nul 2>&1
call :log "DNS cache flushed"

call :log "Resetting Network Stack..."
netsh int ip reset >nul 2>&1
netsh winsock reset >nul 2>&1
call :log "Network stack reset completed"
goto :eof

:step_recycle
call :log "Cleaning Recycle Bin..."
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
call :log "Recycle Bin emptied"

call :log "Cleaning Thumbnail Cache..."
powershell -Command "Remove-Item -Path '%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db' -Force -ErrorAction SilentlyContinue" >nul 2>&1
call :log "Thumbnail cache cleared"
goto :eof

:step_legacy
call :log "Cleaning Legacy System Paths..."
for %%P in (
    "C:\Windows\Tempor~1"
    "C:\Windows\Tmp"
    "C:\Windows\History"
    "C:\Windows\Cookies"
    "C:\Windows\Recent"
    "%SystemRoot%\System32\spool\PRINTERS"
) do (
    if exist "%%P" (
        powershell -Command "Remove-Item -Path '%%P\*' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
    )
)
call :log "Legacy paths cleaned successfully"
goto :eof

:step_advanced
call :log "Performing Advanced System Optimization..."
:: DISM Cleanup
dism /online /cleanup-image /startcomponentcleanup /resetbase >nul 2>&1
call :log "DISM component cleanup completed"

:: Windows Defender Cache
if exist "%ProgramData%\Microsoft\Windows Defender\Scans\History" (
    powershell -Command "Remove-Item -Path '%ProgramData%\Microsoft\Windows Defender\Scans\History\*' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
)
call :log "Windows Defender cache cleared"

:: Temporary Internet Files
powershell -Command "Remove-Item -Path '%LocalAppData%\Microsoft\Windows\INetCache\*' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1
call :log "Temporary Internet Files cleaned"

:: System Restore Points (Optional - comment out if not needed)
:: vssadmin delete shadows /all /quiet >nul 2>&1
call :log "Advanced optimizations completed"
goto :eof

:log
set "timestamp=[%date% %time%]"
echo %timestamp% %1
echo %timestamp% %1 >> "%log_file%"
goto :eof

:end
color 0A
echo.
echo ============================================================
echo [SUCCESS] All Cleanup Operations Completed Successfully!
echo Log saved to: %log_file%
echo ============================================================
echo.
echo Thank you for using Cash Cleaner V3.0!
echo For updates: https://github.com/TAHAPRO10X/CACHE-CLEANER-FOR-WINDOWS
echo.
pause
exit /b 0

:exit
color 0C
echo [EXIT] Cash Cleaner terminated by user
exit /b 0
