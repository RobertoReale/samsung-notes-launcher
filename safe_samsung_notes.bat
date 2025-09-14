@echo off
set "params=%*"
cd /d "%~dp0"
pushd "%~dp0"

:: Check for admin privileges
( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" )
fsutil dirty query %systemdrive% 1>nul 2>nul || (  
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" 
    "%temp%\getadmin.vbs" 
    exit /B 
)

:: Create backup file with timestamp
set "backup_file=%temp%\samsung_notes_backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.txt"
set "backup_file=%backup_file: =0%"

echo Creating backup at: %backup_file%

:: Store the previous system product name and system manufacturer in backup file
for /f "tokens=2*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemProductName ^| find "REG_SZ"') do (
    set "prev_product_name=%%b"
    echo SystemProductName=%%b >> "%backup_file%"
)
for /f "tokens=2*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemManufacturer ^| find "REG_SZ"') do (
    set "prev_manufacturer=%%b"
    echo SystemManufacturer=%%b >> "%backup_file%"
)

:: Verify backup was created
if not exist "%backup_file%" (
    echo ERROR: Failed to create backup file. Aborting for safety.
    pause
    exit /b 1
)

echo Original values backed up successfully.
echo Product Name: %prev_product_name%
echo Manufacturer: %prev_manufacturer%

:: Create restoration script
set "restore_script=%temp%\restore_samsung_values.bat"
echo @echo off > "%restore_script%"
echo echo Restoring original system values... >> "%restore_script%"
echo reg add "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemProductName /t REG_SZ /d "%prev_product_name%" /f >> "%restore_script%"
echo reg add "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemManufacturer /t REG_SZ /d "%prev_manufacturer%" /f >> "%restore_script%"
echo echo Restoration complete. >> "%restore_script%"
echo del "%backup_file%" 2^>nul >> "%restore_script%"
echo del "%restore_script%" 2^>nul >> "%restore_script%"

:: Set the new system product name and system manufacturer
echo Temporarily changing system identification...
reg add "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemProductName /t REG_SZ /d "NP960XFG-KC4UK" /f
if errorlevel 1 (
    echo ERROR: Failed to modify SystemProductName. Aborting.
    goto :restore_and_exit
)

reg add "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemManufacturer /t REG_SZ /d "Samsung" /f
if errorlevel 1 (
    echo ERROR: Failed to modify SystemManufacturer. Restoring and aborting.
    goto :restore_and_exit
)

:: Start Samsung Notes
echo Starting Samsung Notes...
start shell:AppsFolder\SAMSUNGELECTRONICSCoLtd.SamsungNotes_wyx1vj98g3asy!App

:: Wait for Samsung Notes to start
echo Waiting for Samsung Notes to initialize...
timeout /t 5

:restore_and_exit
:: Restore the previous system product name and system manufacturer
echo Restoring original values...
reg add "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemProductName /t REG_SZ /d "%prev_product_name%" /f
reg add "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemManufacturer /t REG_SZ /d "%prev_manufacturer%" /f

:: Verify restoration
echo Verifying restoration...
for /f "tokens=2*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemProductName ^| find "REG_SZ"') do set "current_product=%%b"
for /f "tokens=2*" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v SystemManufacturer ^| find "REG_SZ"') do set "current_manufacturer=%%b"

if "%current_product%"=="%prev_product_name%" (
    if "%current_manufacturer%"=="%prev_manufacturer%" (
        echo SUCCESS: Original values restored successfully.
        del "%backup_file%" 2>nul
        del "%restore_script%" 2>nul
    ) else (
        echo WARNING: Manufacturer restoration may have failed.
        echo Run: %restore_script%
    )
) else (
    echo WARNING: Product name restoration may have failed.
    echo Run: %restore_script%
)

echo Script completed.
pause
exit