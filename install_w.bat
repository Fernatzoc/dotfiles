@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "DOTFILES_DIR=%~dp0"
if "%DOTFILES_DIR:~-1%"=="\" set "DOTFILES_DIR=%DOTFILES_DIR:~0,-1%"

set "NVIM_SRC_PATH=%DOTFILES_DIR%\nvim"
set "ALACRITTY_SRC_PATH=%DOTFILES_DIR%\alacritty"
set "POWERSHELL_PROFILE_SRC_PATH=%DOTFILES_DIR%\Microsoft.PowerShell_profile.ps1"

set "NVIM_LINK_PATH=%LOCALAPPDATA%\nvim"
set "ALACRITTY_LINK_PATH=%APPDATA%\alacritty"
set "POWERSHELL7_PROFILE_LINK_PATH=%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
set "WINDOWSPOWERSHELL_PROFILE_LINK_PATH=%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

call :ensure_link "Neovim" "%NVIM_LINK_PATH%" "%NVIM_SRC_PATH%"
if errorlevel 1 goto :end

call :ensure_link "Alacritty" "%ALACRITTY_LINK_PATH%" "%ALACRITTY_SRC_PATH%"
if errorlevel 1 goto :end

call :ensure_file_link "PowerShell 7 profile" "%POWERSHELL7_PROFILE_LINK_PATH%" "%POWERSHELL_PROFILE_SRC_PATH%"
if errorlevel 1 goto :end

call :ensure_file_link "Windows PowerShell profile" "%WINDOWSPOWERSHELL_PROFILE_LINK_PATH%" "%POWERSHELL_PROFILE_SRC_PATH%"
if errorlevel 1 goto :end

call :ensure_fzf
call :ensure_terminal_icons
call :ensure_terminal_icons_pwsh_link

echo.
echo All links created successfully.
goto :end

:ensure_link
set "APP_NAME=%~1"
set "DEST=%~2"
set "SRC=%~3"

if not exist "%SRC%" (
    echo [ERROR] %APP_NAME% source not found: "%SRC%"
    exit /b 1
)

for %%I in ("%DEST%") do (
    set "DEST_PARENT=%%~dpI"
    set "DEST_NAME=%%~nxI"
)

if not exist "%DEST_PARENT%" mkdir "%DEST_PARENT%"

if exist "%DEST%" (
    dir /AL "%DEST_PARENT%" 2>nul | findstr /I /C:"%DEST_NAME%" >nul
    if not errorlevel 1 (
        echo Existing link found for %APP_NAME%. Removing old link...
        rmdir "%DEST%"
        if errorlevel 1 (
            echo [ERROR] Could not remove old link: "%DEST%"
            exit /b 1
        )
    ) else (
        call :timestamp
        set "BACKUP_PATH=!DEST!.backup_!TIMESTAMP!"
        echo Existing folder/file found for %APP_NAME%. Creating backup:
        echo "%BACKUP_PATH%"
        move "%DEST%" "%BACKUP_PATH%" >nul
        if errorlevel 1 (
            echo [ERROR] Could not back up existing path: "%DEST%"
            exit /b 1
        )
    )
)

mklink /D "%DEST%" "%SRC%" >nul
if errorlevel 1 (
    echo [ERROR] Failed to create %APP_NAME% link.
    echo Run this script as Administrator or enable Developer Mode.
    exit /b 1
)

echo %APP_NAME% configuration linked successfully.
exit /b 0

:ensure_file_link
set "APP_NAME=%~1"
set "DEST=%~2"
set "SRC=%~3"

if not exist "%SRC%" (
    echo [ERROR] %APP_NAME% source not found: "%SRC%"
    exit /b 1
)

for %%I in ("%DEST%") do set "DEST_PARENT=%%~dpI"
if not exist "%DEST_PARENT%" mkdir "%DEST_PARENT%"

if exist "%DEST%" (
    for %%I in ("%DEST%") do set "DEST_ATTR=%%~aI"
    if not "!DEST_ATTR:l=!"=="!DEST_ATTR!" (
        echo Existing link found for %APP_NAME%. Removing old link...
        del "%DEST%" >nul 2>&1
        if exist "%DEST%" rmdir "%DEST%" >nul 2>&1
        if exist "%DEST%" (
            echo [ERROR] Could not remove old link: "%DEST%"
            exit /b 1
        )
    ) else (
        call :timestamp
        set "BACKUP_PATH=!DEST!.backup_!TIMESTAMP!"
        echo Existing file found for %APP_NAME%. Creating backup:
        echo "%BACKUP_PATH%"
        move "%DEST%" "%BACKUP_PATH%" >nul
        if errorlevel 1 (
            echo [ERROR] Could not back up existing file: "%DEST%"
            exit /b 1
        )
    )
)

mklink "%DEST%" "%SRC%" >nul
if errorlevel 1 (
    echo [ERROR] Failed to create %APP_NAME% link.
    echo Run this script as Administrator or enable Developer Mode.
    exit /b 1
)

echo %APP_NAME% linked successfully.
exit /b 0

:timestamp
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "TIMESTAMP=%%I"
exit /b 0

:ensure_fzf
where fzf >nul 2>&1
if not errorlevel 1 (
    echo fzf is already installed.
    exit /b 0
)

where winget >nul 2>&1
if errorlevel 1 (
    echo [WARN] winget is not available. Install fzf manually: winget install --id junegunn.fzf -e
    exit /b 0
)

echo Installing fzf via winget...
winget install --id junegunn.fzf --exact --source winget --accept-package-agreements --accept-source-agreements --silent
if errorlevel 1 (
    echo [WARN] Could not install fzf automatically.
) else (
    echo fzf installed successfully.
)
exit /b 0

:ensure_terminal_icons
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo -NoProfile -Command "if (Get-Module -ListAvailable -Name Terminal-Icons) { exit 0 } else { exit 1 }" >nul 2>&1
if not errorlevel 1 (
    echo Terminal-Icons is already installed.
    exit /b 0
)

echo Installing Terminal-Icons PowerShell module...
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo -NoProfile -Command "Install-PackageProvider -Name NuGet -Force -Scope CurrentUser; Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction SilentlyContinue; Install-Module -Name Terminal-Icons -Scope CurrentUser -Repository PSGallery -Force -AllowClobber"
if errorlevel 1 (
    echo [WARN] Could not install Terminal-Icons automatically.
) else (
    echo Terminal-Icons installed successfully.
)
exit /b 0

:ensure_terminal_icons_pwsh_link
set "TERMINAL_ICONS_MODULE_ROOT=%USERPROFILE%\Documents\WindowsPowerShell\Modules\Terminal-Icons"
set "TERMINAL_ICONS_PWSH_ROOT=%USERPROFILE%\Documents\PowerShell\Modules\Terminal-Icons"
set "TERMINAL_ICONS_WINPS="

if not exist "%TERMINAL_ICONS_MODULE_ROOT%" (
    echo [WARN] Windows PowerShell Terminal-Icons module not found.
    exit /b 0
)

for /f "delims=" %%V in ('dir /b /ad /o-n "%TERMINAL_ICONS_MODULE_ROOT%"') do (
    set "TERMINAL_ICONS_WINPS=%TERMINAL_ICONS_MODULE_ROOT%\%%V"
    set "TERMINAL_ICONS_PWSH=%TERMINAL_ICONS_PWSH_ROOT%\%%V"
    goto :terminal_icons_version_found
)

echo [WARN] No Terminal-Icons version folder was found.
exit /b 0

:terminal_icons_version_found
call :ensure_link "Terminal-Icons PowerShell 7 module" "%TERMINAL_ICONS_PWSH%" "%TERMINAL_ICONS_WINPS%"
if errorlevel 1 (
    echo [WARN] Could not create shared Terminal-Icons module link for PowerShell 7.
)
exit /b 0

:end
echo.
pause
