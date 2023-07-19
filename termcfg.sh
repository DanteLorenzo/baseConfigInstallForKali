#! /usr/bin/env bash

#Terminal settings
mkdir ~/.local/share/fonts
cp ./fonts/Hack.zip ~/.local/share/fonts/
unzip ~/.local/share/fonts/Hack.zip
rm ~/.local/share/fonts/Hack.zip
fc-cache -fv

#export main terminal cfg
#dconf dump /org/gnome/terminal/ > gnome-terminal-cfg.dconf

#import main terminal cfg
#cat ./terminalcfg/gnome-terminal-profiles.dconf | dconf load /org/gnome/terminal/

#export profile
#dconf dump /org/gnome/terminal/legacy/profiles:/ > gnome-terminal-profiles.dconf

#import profile
dconf load /org/gnome/terminal/legacy/profiles:/ < ./terminalcfg/gnome-terminal-cfg.dconf


#NVIM
wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O ~/nvim
chmod +x ~/nvim
sudo chown root:root ~/nvim
sudo mv ~/nvim /usr/bin
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

#tmux
sudo apt install -y tmux
sudo mkdir ~/.config/tmux
cp ./tmux/tmux.conf ~/.config/tmux/

