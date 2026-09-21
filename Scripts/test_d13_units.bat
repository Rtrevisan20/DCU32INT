@echo off
cd /d "%~dp0..\Packages\Delphi"
.\dcu32int.exe "%TEMP%\opencode\delphi13dcu\testunit2.dcu" -U* 2>&1 | findstr "Total\|Error"
.\dcu32int.exe "%TEMP%\opencode\delphi13dcu\testunit6.dcu" -U* 2>&1 | findstr "Total\|Error"
.\dcu32int.exe "%TEMP%\opencode\delphi13dcu\testunit8.dcu" -U* 2>&1 | findstr "Total\|Error"
.\dcu32int.exe "%TEMP%\opencode\delphi13dcu\testunit12.dcu" -U* 2>&1 | findstr "Total\|Error"
.\dcu32int.exe "%TEMP%\opencode\delphi13dcu\testunit13.dcu" -U* 2>&1 | findstr "Total\|Error"