@echo off
cd /d "%~dp0"
"C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\dcc32.exe" -dI64 -NSsystem;winapi -U"..\src" -U"..\Packages\lib11" "..\Packages\Delphi\dcu32int.dpr"