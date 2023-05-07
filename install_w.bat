@echo off
setlocal

set "USERNAME=%USERNAME%"

:: Remove existing symbolic links
set "NVIM_LINK_PATH=C:\Users\%USERNAME%\AppData\Local\nvim"
if exist "%NVIM_LINK_PATH%" (
    rmdir /S /Q "%NVIM_LINK_PATH%"
)

set "ALACRITTY_LINK_PATH=C:\Users\%USERNAME%\AppData\Roaming\alacritty"
if exist "%ALACRITTY_LINK_PATH%" (
    rmdir /S /Q "%ALACRITTY_LINK_PATH%"
)

:: Create symbolic links for Neovim and Alacritty
set "NVIM_SRC_PATH=C:\Users\%USERNAME%\dotfiles\nvim"
set "ALACRITTY_SRC_PATH=C:\Users\%USERNAME%\dotfiles\alacritty"

mklink /D "%NVIM_LINK_PATH%" "%NVIM_SRC_PATH%"
echo Neovim configuration linked successfully.

mklink /D "%ALACRITTY_LINK_PATH%" "%ALACRITTY_SRC_PATH%"
echo Alacritty configuration linked successfully.

pause
