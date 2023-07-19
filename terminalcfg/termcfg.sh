#! /usr/bin/env bash


mkdir ~/.local/share/fonts
cp ../fonts/Hack.zip ~/.local/share/fonts/
unzip ~/.local/share/fonts/Hack.zip
rm ~/.local/share/fonts/Hack.zip
fc-cache -fv



#dconf dump /org/gnome/terminal/legacy/profiles:/ > gnome-terminal-profiles.dconf
dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf


wget --quiet https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O ~/Downloads/nvim
chmod +x ~/Downloads/nvim 
sudo chown root:root ~/Downloads/nvim 
sudo mv ~/Downloads/nvim /usr/bin
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

sudo apt install -y tmux

