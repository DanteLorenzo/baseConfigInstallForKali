#! /bin/bash

sudo apt update -y && sudo apt upgrade -y
sudo apt install nvidia-driver nvidia-cuda-toolkit
sudo apt install -y wireguard resolvconf \
		    wget gnupg lsb-release apt-transport-https ca-certificates \
		    hashcat telegram-desktop elinks ansible remmina \
		    docker.io variety software-properties-common \
	            bluetooth bluez bluez-tools rfkill blueman \
                    wine golang gimp macchanger \
		    qemu-utils qemu-kvm virt-manager bridge-utils \
                    cargo simplescreenrecorder python3-pip python3.11-venv \
		    gparted airgeddon gobuster yt-dlp vlc qbittorrent \
		    cal
#Pictures
mv ./pic/* ~/Pictures/

#Variety
rm ~/.config/variety/variety.conf
mv ./variety/variety.conf ~/.config/variety/

#Keyboard shortcuts
cat ./keyboard/dump_1 | dconf load /org/gnome/settings-daemon/plugins/media-keys/
cat ./keyboard/dump_2 | dconf load /org/gnome/desktop/wm/keybindings/
cat ./keyboard/dump_3 | dconf load /org/gnome/shell/keybindings/
cat ./keyboard/dump_4 | dconf load /org/gnome/mutter/keybindings/
cat ./keyboard/dump_5 | dconf load /org/gnome/mutter/wayland/keybindings/

#GRUB
sudo mkidr /boot/grub/themes/diana
sudo cp ./grub/theme.txt /boot/grub/themes/diana/
sudo cp ./grub/grub /etc/default/grub
sudo rm -rf /etc/default/grub.d

#Docker
echo "Setup Docker"
sudo usermod -aG docker $USER
printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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
echo "Install Virtualbox"
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox_2016.gpg
curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox.gpg
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bullseye contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt install -y dkms
sudo apt install -y virtualbox virtualbox-ext-pack

#Steam
echo "Install Steam"
wget -O ~/Downloads/steam.deb 'https://cdn.akamai.steamstatic.com/client/installer/steam.deb'
sudo dpkg -i ~/Downloads/steam.deb

#Postman
wget -O ~/Downloads/postman.tar.gz 'https://dl.pstmn.io/download/latest/linux_64'
sudo tar -xzvf ~/Downloads/postman.tar.gz -C /opt
mv ./postman/Postman.desktop ~/.local/share/applications/Postman.desktop

#Settings
sudo dpkg --add-architecture i386
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt>Shift_L']"       
sudo systemctl enable bluetooth.service 

#Macchanger
sudo mv ./mac/macspoof@wlan0.service /etc/systemd/system/
sudo systemctl enable macspoof@wlan0.service

#Zshrc
echo 'PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
echo 'export PATH="${PATH}:${HOME}/.cargo/bin"' >> ~/.zshrc
source ~/.zshrc

#Obsidian
cargo install htmlq
wget -O ~/Downloads/obsidian.deb $(curl --silent https://obsidian.md/download | htmlq --attribute href a | grep .deb)
sudo dpkg -i ~/Downloads/obsidian.deb

#Clear system
echo "Clear System"
sudo apt --fix-broken install
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
sudo rm -rf ~/Downloads/

echo "Installation complete"
