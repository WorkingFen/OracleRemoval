@ECHO OFF&CLS
setlocal EnableDelayedExpansion

call :resume
call :%current%
exit /b %ERRORLEVEL%

:: Remove oracle environment variable
:RemoveOracleEnvVariable
set $line=%PATH%
set $line=%$line: =#%
set $line=%$line:;= %
set $line=%$line:)=^^)%

for %%a in (%$line%) do ( 
	echo %%a | find /i "app\%USERNAME%\product" >nul || set $newpath=!$newpath!;%%a
)
set $newpath=!$newpath:#= !
set $newpath=!$newpath:^^=!
echo !$newpath:~1!
:: echo set path=!$newpath:~1!
exit /b 0

:: Remove Oracle Registries
:RemoveOracleRegs
echo "Hi"
exit /b 0

:: Resume script's work
:resume
if exist "%~dp0script.or" (
	set /p current=<"%~dp0script.or"
)
else (
	set current=first
)

exit /b 0

:: First section which will be executed
:first
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v "%~n0" /d "%~dpnx0" /f
echo last >"%~dp0current.or"
call :RemoveOracleEnvVariable
call :RemoveOracleRegs
pause
shutdown -r -t 0
exit /b 0

:: Last section which will be executed
:last
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v %~n0 /f
del "%~dp0current.or"
pause
exit /b 0