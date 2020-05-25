@ECHO OFF&CLS
setlocal EnableDelayedExpansion

call :resume
call :%current%
exit /b %ERRORLEVEL%

:: Remove Oracle's environment variable
:RemoveOracleEnvVariable
set $line=%PATH%
set $line=%$line: =#%
set $line=%$line:;= %
set $line=%$line:)=^^)%

for %%a in (%$line%) do ( 
	echo %%a | find /i "app\%USERNAME%\product" >>"%~dp0script.or" || set $newpath=!$newpath!;%%a
)
set $newpath=!$newpath:#= !
set $newpath=!$newpath:^^=!
:: echo set path=!$newpath:~1!
exit /b 0

:: Remove Oracle's registries
:RemoveOracleRegs
for /f "usebackq" %%i in (`reg query HKLM\SOFTWARE\ORACLE /K /F ora`) do (
	echo %%i | find /i "End" >nul || echo %%i
)
:: reg delete %%i /f >nul

for /f "usebackq" %%i in (`reg query HKLM\SOFTWARE\ORACLE /K /C /F ODP`) do (
	echo %%i | find /i "End" >nul || echo %%i
)
:: reg delete %%i /f >nul

for /f "usebackq" %%i in (`reg query HKLM\SYSTEM\CurrentControlSet\Services /K /C /F ORCL`) do (
	echo %%i | find /i "End" >nul || echo %%i
)
:: reg delete %%i /f >nul

for /f "usebackq" %%i in (`reg query HKLM\SYSTEM\CurrentControlSet\Services /K /C /F OraDB`) do (
	echo %%i | find /i "End" >nul || echo %%i
)
:: reg delete %%i /f >nul
exit /b 0

:: Remove Oracle's main directory
: RemoveOracleMainDir
:: rmdir /Q /S %dir:~0,7%
exit /b 0

:: Remove Oracle's start menu directory
: RemoveOracleMenuDir
set menuDir=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\
for /f "usebackq delims=" %%i in (`dir "%menuDir%" /A:D /B ^| find "OraDB" `) do (
	echo %menu_dir%%%i
)
:: rmdir /Q /S %menu_dir%%%i
exit /b 0

:: Open computer management to delete manually all additional users
: OpenUsers
echo ###### Remove all users and groups which correspond to OracleDB
lusrmgr.msc
exit /b 0

:: Resume script's work
:resume
if exist "%~dp0script.or" (
	set /p current=<"%~dp0script.or" >nul
	for /f "skip=1 delims=" %%i in (%~dp0script.or) do set dir=%%i >nul
) else (
	set current=first >nul
)
exit /b 0

:: First section which will be executed
:first
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v "%~n0" /d "%~dpnx0" /f >nul
echo last >"%~dp0script.or"
call :RemoveOracleEnvVariable
call :RemoveOracleRegs
echo ###### Make sure all your open files are saved. ####
echo ###### All unsaved changes will be lost. ###########
pause
:: shutdown /r /t 0 /d p:4:1
exit /b 0

:: Last section which will be executed
:last
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v "%~n0" /f >nul
del "%~dp0script.or
call :RemoveOracleMainDir
call :RemoveOracleMenuDir
call :OpenUsers
echo ###### All your Oracle data has been deleted. ######
pause
exit /b 0