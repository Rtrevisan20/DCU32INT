@echo off
cd /d "%~dp0"
"C:\lazarus\fpc\3.2.2\bin\x86_64-win64\fpc.exe" -Mdelphi -dI64 -Fu"..\src" "..\Packages\Delphi\dcu32int.dpr"