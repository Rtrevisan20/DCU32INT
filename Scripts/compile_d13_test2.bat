@echo off
set LIBDIR=%TEMP%\opencode\d13lib
set SRC=%TEMP%\opencode\delphi13dcu
mkdir %LIBDIR% 2>nul
copy "C:\Program Files (x86)\Embarcadero\Studio\37.0\lib\win32\release\*.dcu" %LIBDIR% >nul
copy "C:\Program Files (x86)\Embarcadero\Studio\37.0\lib\win32\release\*.dcp" %LIBDIR% >nul

"C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\dcc32.exe" -Q -dI64 -U%LIBDIR% "%SRC%\testunit2.pas"
"C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\dcc32.exe" -Q -dI64 -U%LIBDIR% "%SRC%\testunit6.pas"
"C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\dcc32.exe" -Q -dI64 -U%LIBDIR% "%SRC%\testunit8.pas"
"C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\dcc32.exe" -Q -dI64 -U%LIBDIR% "%SRC%\testunit12.pas"
"C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\dcc32.exe" -Q -dI64 -U%LIBDIR% "%SRC%\testunit13.pas"