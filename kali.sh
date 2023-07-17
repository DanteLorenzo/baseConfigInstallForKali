#! /usr/bin/env bash

sudo apt update -y && sudo apt upgrade -y
sudo apt install -y nvidia-driver nvidia-cuda-toolkit
sudo apt install -y wireguard resolvconf \
		    wget gnupg lsb-release apt-transport-https ca-certificates \
		    hashcat telegram-desktop elinks ansible remmina \
		    docker.io software-properties-common \
	            bluetooth pkg-config libssl-dev ncal\
                    wine golang gimp macchanger \
		    qemu-utils qemu-kvm virt-manager bridge-utils \
                    simplescreenrecorder python3-pip python3.11-venv \
		    gparted airgeddon gobuster yt-dlp vlc qbittorrent

#Pictures
cp -r ./pic/* /home/$USER/Pictures/

#SetWallpapers
sudo cp ./bgscript/set_wallpaper /usr/bin/
crontab -l > mycron
echo "* * * * * env DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus set_wallpaper $HOME/Pictures/Backgrounds/$(ls $HOME/Pictures/Backgrounds | shuf -n 1)" >> mycron
crontab mycron
rm mycron 

#Rust
clear
echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#Keyboard sources and shortcuts
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"
cat ./keyboard/dump_1 | dconf load /org/gnome/settings-daemon/plugins/media-keys/
cat ./keyboard/dump_2 | dconf load /org/gnome/desktop/wm/keybindings/
cat ./keyboard/dump_3 | dconf load /org/gnome/shell/keybindings/
cat ./keyboard/dump_4 | dconf load /org/gnome/mutter/keybindings/
cat ./keyboard/dump_5 | dconf load /org/gnome/mutter/wayland/keybindings/

#GRUB
sudo mkdir /boot/grub/themes/diana
sudo cp ./grub/theme.txt /boot/grub/themes/diana/
sudo cp ./grub/grub /etc/default/grub
sudo rm -rf /etc/default/grub.d
sudo rm /usr/share/grub/themes/kali/grub-4x3.png /usr/share/grub/themes/kali/grub-16x9.png
sudo update-grub

#Docker
echo "Setup Docker"
sudo usermod -aG docker $USER
printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#sudo chmod 666 /var/run/docker.sock
newgrp docker

#Qemu
echo "Qemu setup"
sudo useradd -g $USER libvirt
sudo useradd -g $USER libvirt-kvm
sudo systemctl enable libvirtd.service && sudo systemctl start libvirtd.service

#Librewolf
echo "Install Librewolf"
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

#Wireguard
echo "Start setup Wireguard settings"
sudo chmod +xr /etc/wireguard
sudo touch /etc/wireguard/wg0.conf
sudo systemctl enable wg-quick@wg0

#VSCode
echo "Install VSCode"
wget -O ~/Downloads/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo dpkg -i ~/Downloads/vscode.deb

#Discord
echo "Install Discord"
wget -O ~/Downloads/discord.deb 'https://discord.com/api/download?platform=linux&format=deb'
sudo dpkg -i ~/Downloads/discord.deb 

#Virtualbox
#echo "Install Virtualbox"
#curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/#oracle_vbox_2016.gpg
#curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox.gpg
#echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bullseye contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
#sudo apt update
#sudo apt install -y dkms
#sudo apt install -y virtualbox virtualbox-ext-pack

#Steam
echo "Install Steam"
wget -O ~/Downloads/steam.deb 'https://cdn.akamai.steamstatic.com/client/installer/steam.deb'
sudo dpkg -i ~/Downloads/steam.deb

#Postman
wget -O ~/Downloads/postman.tar.gz 'https://dl.pstmn.io/download/latest/linux_64'
sudo tar -xzvf ~/Downloads/postman.tar.gz -C /opt
cp ./postman/Postman.desktop ~/.local/share/applications/Postman.desktop

#Settings
sudo dpkg --add-architecture i386
#gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt>Shift_L']"       
sudo systemctl enable bluetooth.service 

#Macchanger
sudo mv ./mac/macspoof@wlan0.service /etc/systemd/system/
sudo systemctl enable macspoof@wlan0.service


#Obsidian
cargo install htmlq
wget -O ~/Downloads/obsidian.deb $(curl --silent https://obsidian.md/download | htmlq --attribute href a | grep .deb)
sudo dpkg -i ~/Downloads/obsidian.deb

#Clear system
echo "Clear System"
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

echo "Installation complete"
