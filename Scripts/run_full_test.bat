@echo off
setlocal

set D11_LIB=C:\Program Files (x86)\Embarcadero\Studio\22.0\lib\win32\release
set D13_LIB=C:\Program Files (x86)\Embarcadero\Studio\37.0\lib\win32\release
set TEMP_D11=%TEMP%\opencode\d11_testlib
set TEMP_D13=%TEMP%\opencode\d13_testlib
set OUT_DIR=%TEMP%\opencode\test_results
set EXE=%~dp0..\Packages\Delphi\dcu32int.exe

mkdir "%TEMP_D11%" 2>nul
mkdir "%TEMP_D13%" 2>nul
mkdir "%OUT_DIR%" 2>nul

echo Copying D11 DCUs...
copy "%D11_LIB%\*.dcu" "%TEMP_D11%\" >nul
echo Copying D13 DCUs...
copy "%D13_LIB%\*.dcu" "%TEMP_D13%\" >nul

echo.
echo ========================================
echo Testing Delphi 11 (32-bit) - 1814 DCUs
echo ========================================
cd /d "%OUT_DIR%"
del d11_results.txt 2>nul
for %%F in ("%TEMP_D11%\*.dcu") do (
    echo Testing %%~nF...
    "%EXE%" "%%F" -U* -AC -I 2>&1 | findstr "Total\|Error" >> d11_results.txt
)

echo.
echo ========================================
echo Testing Delphi 13 (32-bit) - 1890 DCUs
echo ========================================
del d13_results.txt 2>nul
for %%F in ("%TEMP_D13%\*.dcu") do (
    echo Testing %%~nF...
    "%EXE%" "%%F" -U* -AC -I 2>&1 | findstr "Total\|Error" >> d13_results.txt
)

echo.
echo ========================================
echo SUMMARY
echo ========================================
echo D11:
find /c "Total" d11_results.txt
find /c "Error" d11_results.txt
echo D13:
find /c "Total" d13_results.txt
find /c "Error" d13_results.txt

endlocal