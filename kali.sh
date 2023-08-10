#! /usr/bin/env bash

echo "Installation start"

#Update system and install packages
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y nvidia-driver nvidia-cuda-toolkit
sudo apt install -y wireguard resolvconf \
		    wget gnupg lsb-release apt-transport-https ca-certificates \
		    hashcat telegram-desktop elinks ansible remmina \
		    docker.io software-properties-common \
	      	    bluetooth pkg-config libssl-dev ncal\
        	    wine wine32:i386 golang gimp macchanger \
		    qemu-utils qemu-kvm libvirt-daemon-system libvirt-clients virt-manager bridge-utils \
        	    simplescreenrecorder python3-pip python3.11-venv \
		    gparted airgeddon gobuster yt-dlp vlc qbittorrent \
		    zenmap-kbx sqlitebrowser htop vagrant

#Pictures
clear
echo "Start: copy images"
cp -r ./pic/* /home/$USER/Pictures/
echo "End: copy images"

#SetWallpapers
echo "Start: set wallpaper script"
sudo chmod 755 ./bgscript/set_wallpaper
sudo cp ./bgscript/set_wallpaper /usr/bin/
crontab -l > mycron
echo '* * * * * env DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus set_wallpaper $HOME/Pictures/Backgrounds/$(ls $HOME/Pictures/Backgrounds | shuf -n 1)' >> mycron
crontab mycron
rm mycron 
echo "End: set wallpaper script"

#Asciiquarium
#wget -O ~/Downloads/Term-anim.tar.gz 'http://search.cpan.org/CPAN/authors/id/K/KB/KBAUCOM/Term-Animation-2.6.tar.gz'
#tar -zxvf Term-Animation-2.6.tar.gz -C ~/Downloads/
#perl ~/Downloads/Term-Animation-2.6/Makefile.PL
#~/Downloads/Term-Animation-2.6/make
#~/Downloads/Term-Animation-2.6/make test
#sudo ~/Downloads/Term-Animation-2.6/make install
#wget -O ~/Downloads/ascii.tar.gz --no-check-certificate 'http://www.robobunny.com/projects/asciiquarium/asciiquarium.tar.gz'
#tar -zxvf asciiquarium.tar.gz -C ~/Downloads/
#sudo cp ~/Downloads/ascii/asciiquarium /usr/local/bin/
#sudo chmod 0755 /usr/local/bin/asciiquarium

#Rust
clear
echo "Start: install Rust"
echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo "End: install Rust"

#Keyboard sources and shortcuts
clear
echo "Start: keyboard settings"
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"
cat ./keyboard/dump_1 | dconf load /org/gnome/settings-daemon/plugins/media-keys/
cat ./keyboard/dump_2 | dconf load /org/gnome/desktop/wm/keybindings/
cat ./keyboard/dump_3 | dconf load /org/gnome/shell/keybindings/
cat ./keyboard/dump_4 | dconf load /org/gnome/mutter/keybindings/
cat ./keyboard/dump_5 | dconf load /org/gnome/mutter/wayland/keybindings/
echo "End: keyboard settings"

#GRUB
echo "Start: grub configure"
sudo mkdir /boot/grub/themes/diana
sudo cp ./grub/theme.txt /boot/grub/themes/diana/
sudo cp ./grub/grub /etc/default/grub
sudo rm -rf /etc/default/grub.d
sudo rm /usr/share/grub/themes/kali/grub-4x3.png /usr/share/grub/themes/kali/grub-16x9.png
sudo update-grub
echo "End: grub configure"

#Qemu/KVM
echo "Start: qemu setup"
sudo useradd -g $USER libvirt
sudo useradd -g $USER libvirt-kvm
sudo systemctl enable libvirtd.service && sudo systemctl start libvirtd.service
echo "End: qemu setup"

#Librewolf
clear
echo "Start: install Librewolf"
distro=$(if echo " una vanessa focal jammy bullseye vera uma" | grep -q " $(lsb_release -sc) "; then echo $(lsb_release -sc); else echo focal; fi)
wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF

sudo apt update -y
sudo apt install -y librewolf
echo "End: install Librewolf"

#Wireguard
clear
echo "Start: setup Wireguard base conf"
sudo chmod +xr /etc/wireguard
sudo touch /etc/wireguard/wg0.conf
sudo systemctl enable wg-quick@wg0
echo "End: setup Wireguard base conf"

#VSCode
clear
echo "Start: install VSCode"
wget -O ~/Downloads/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo dpkg -i ~/Downloads/vscode.deb
echo "End: install VSCode"

#Discord
clear
echo "Start: install Discord"
wget -O ~/Downloads/discord.deb 'https://discord.com/api/download?platform=linux&format=deb'
sudo dpkg -i ~/Downloads/discord.deb 
echo "End: install Discord"

#Virtualbox
#clear
#echo "Start: install Virtualbox"
#curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/#oracle_vbox_2016.gpg
#curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox.gpg
#echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bullseye contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
#sudo apt update -y
#sudo apt install -y dkms
#sudo apt install -y virtualbox virtualbox-ext-pack
#echo "End: install Virtualbox"

#Steam
clear
echo "Start: install Steam"
wget -O ~/Downloads/steam.deb 'https://cdn.akamai.steamstatic.com/client/installer/steam.deb'
sudo dpkg -i ~/Downloads/steam.deb
echo "End: isntall Steam"

#Postman
clear
echo "Start: install Postman"
wget -O ~/Downloads/postman.tar.gz 'https://dl.pstmn.io/download/latest/linux_64'
sudo tar -xzvf ~/Downloads/postman.tar.gz -C /opt
cp ./postman/Postman.desktop ~/.local/share/applications/Postman.desktop
echo "End: install Postman"

#Settings
clear
echo "Start: Settings on"
sudo dpkg --add-architecture i386
#gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt>Shift_L']"       
sudo systemctl enable bluetooth.service 
echo "End: Settings on"

#Macchanger
clear
echo "Start: setting Macchanger"
sudo mv ./mac/macspoof@wlan0.service /etc/systemd/system/
sudo systemctl enable macspoof@wlan0.service
echo "End: setting Macchanger"

#Obsidian
clear
echo "Start: install Obsidian"
cargo install htmlq
wget -O ~/Downloads/obsidian.deb $(curl --silent https://obsidian.md/download | htmlq --attribute href a | grep .deb)
sudo dpkg -i ~/Downloads/obsidian.deb
echo "End: install Obsidian"

#Thunderbird
clear
echo "Start: install Thunderbird"
wget -O ~/Downloads/thunderbird.tar.bz2 $(curl --silent https://www.thunderbird.net/en-US/ | htmlq --attribute href a | grep -m1 "SSL&os=linux64&lang=en-US")
tar xjf thunderbird-*.tar.bz2 -C ~/Downloads/
sudo mv ~/Downloads/thunderbird /opt
sudo ln -s /opt/thunderbird/thunderbird /usr/bin/thunderbird
wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/installing-thunderbird-linux/thunderbird.desktop -P ~/.local/share/applications
echo "End: install Thunder"

#Docker
clear
echo "Start: install Docker"
sudo usermod -aG docker $USER
printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#sudo chmod 666 /var/run/docker.sock
sudo systemctl start docker
newgrp docker
echo "End: install Docker"

#Hack font
mkdir ~/.local/share/fonts  
unzip ./fonts/Hack.zip  -d ~/.local/share/fonts/ 
fc-cache -fv 

#Terminal profile
dconf load /org/gnome/terminal/legacy/profiles:/ < ./terminalcfg/gnome-terminal-profiles.dconf

#NVIM
wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O ~/nvim
chmod +x ~/nvim
sudo chown root:root ~/nvim
sudo mv ~/nvim /usr/bin
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

#tmux
sudo apt install -y tmux
sudo mkdir ~/.config/tmux
sudo cp tmux/tmux.conf ~/.config/tmux/

#Clear system
clear
echo "Start: clear and fix System"
sudo apt --fix-broken -y install
sudo rm -f \
    /etc/apt/sources.list.d/librewolf.sources \
    /etc/apt/keyrings/librewolf.gpg \
    /etc/apt/preferences.d/librewolf.pref \
    /etc/apt/sources.list.d/home_bgstack15_aftermozilla.sources \
    /etc/apt/keyrings/home_bgstack15_aftermozilla.gpg \
    /etc/apt/sources.list.d/librewolf.list \
    /etc/apt/trusted.gpg.d/librewolf.gpg \
    /etc/apt/sources.list.d/home:bgstack15:aftermozilla.list \
    /etc/apt/trusted.gpg.d/home_bgstack15_aftermozilla.gpg
sudo rm -rf ~/Downloads/*
echo "End: clear and fix System"

echo "Installation complete"
