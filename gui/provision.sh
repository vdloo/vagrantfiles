#!/usr/bin/env sh
# remove conflicting guest-dkms
pacman -Rsc virtualbox-guest-dkms --noconfirm --needed
pacman -Syyu --noconfirm && pacman -S ruby git puppet acl xf86-video-vesa --noconfirm --needed

