@echo off
setlocal

set "PWSH_EXE=%ProgramFiles%\PowerShell\7\pwsh.exe"
if exist "%PWSH_EXE%" goto launch

for /f "delims=" %%I in ('where pwsh 2^>nul') do (
	set "PWSH_EXE=%%I"
	goto launch
)

echo pwsh.exe was not found.
exit /b 1

:launch
"%PWSH_EXE%" -NoLogo -NoExit