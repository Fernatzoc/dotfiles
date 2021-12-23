#!/bin/bash

if [[ `uname` == "Linux"   ]]; then
  echo "Linux detected. Using Linux config..."
  #echo "Installing zsh..."
  #sudo apt install zsh
  #echo "Changing shell to zsh"
  #sudo chsh -s $(which zsh)
fi

echo "Installing Oh my zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing zInit"
sh -c "$(curl -fsSL https://git.io/zinit-install)"

echo "Removing existing dotfiles"
# remove files if they already exist
unlink ~/.config/nvim ~/.zshrc ~/.p10k.zsh ~/.tmux ~/.tmux.conf
rm -rf ~/.config/nvim ~/.zshrc ~/.p10k.zsh ~/.tmux ~/.tmux.conf

echo "Creating symlinks"
# Neovim expects some folders already exist
mkdir -p ~/.config

# Symlinking files
ln -s ~/dotfiles/nvim/ ~/.config/
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/p10k.zsh ~/.p10k.zsh
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf


#SSH Settings
echo "Creating SSH Settings"
mkdir -p ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/config
chmod 600 ~/.ssh/config
