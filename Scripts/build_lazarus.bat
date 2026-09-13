@echo off
rem Build do DCU32INT para Lazarus/FPC (dual-IDE)
rem Uso: build_lazarus.bat [lazbuild.exe path]

set LAZBUILD=%1
if "%LAZBUILD%"=="" if exist "C:\lazarus\lazbuild.exe" set LAZBUILD=C:\lazarus\lazbuild.exe
if "%LAZBUILD%"=="" set LAZBUILD=lazbuild

"%LAZBUILD%" -B "..\Packages\Lazarus\dcu32int.lpi"
if errorlevel 1 goto :err

echo.
echo Build concluido: o executavel esta em Compiled\...\
goto :eof

:err
echo.
echo ERRO no build do Lazarus/FPC.
exit /b 1