#!/bin/sh
# type -p pacman \
#	&& pacman --noconfirm -Syyu && pacman --noconfirm -S vim git base-devel abs dmenu xorg-server
pacman -Syyu --noconfirm ; pacman --noconfirm -S vim git base-devel abs dmenu xorg-server xorg-xinit libx11 libxinerama chromium xterm feh scrot xclip
(cd /home/vagrant/.dotfiles-public/code/configs/dwm; bash setup.sh)
echo -e "toor\ntoor" | passwd vagrant 
echo "exec dwm" > /home/vagrant/.xinitrc
chown vagrant /home/vagrant/.xinitrc
