#!/bin/bash

if [[ `uname` == "Linux"   ]]; then
  echo "Linux detected. Using Linux config..."
  #echo "Installing zsh..."
  #sudo apt install zsh
  #echo "Changing shell to zsh"
  #sudo chsh -s $(which zsh)
fi

echo "Removing existing dotfiles"
# remove files if they already exist
unlink ~/.config/nvim ~/.config/kitty ~/.config/alacritty ~/.zshrc ~/.p10k.zsh ~/.tmux ~/.tmux.conf
rm -rf ~/.config/nvim ~/.config/kitty ~/.config/alacritty ~/.zshrc ~/.p10k.zsh ~/.tmux ~/.tmux.conf

echo "Creating symlinks"
# Neovim expects some folders already exist
mkdir -p ~/.config

# Symlinking files
ln -s ~/dotfiles/nvim/ ~/.config/
ln -s ~/dotfiles/kitty/ ~/.config/
ln -s ~/dotfiles/alacritty/ ~/.config/
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/p10k.zsh ~/.p10k.zsh

#With Sudo
#ln -s -f /home/fernatzoc/dotfiles/nvim/ /root/.config/
#ln -s -f /home/fernatzoc/dotfiles/zshrc /root/.zshrc
#ln -s -f /home/fernatzoc/dotfiles/p10k.zsh /root/.p10k.zsh

#ln -s ~/dotfiles/tmux.conf ~/.tmux.conf

#SSH Settings
echo "Creating SSH Settings"
mkdir -p ~/.ssh && chmod -R 700 ~/.ssh
touch ~/.ssh/config
chmod 600 ~/.ssh/config
