#!/bin/bash

echo "Removing existing dotfiles"
# remove files if they already exist
unlink ~/.config/nvim
rm -rf ~/.config/nvim/

echo "Creating symlinks"
# Neovim expects some folders already exist
mkdir -p ~/.config

# Symlinking files
ln -s ~/dotfiles/nvim/ ~/.config/


#SSH Settings
mkdir -p ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/config
chmod 600 ~/.ssh/config
