#!/usr/bin/env sh
userdel terry	# remove image maintainer's user
pacman -Syyu --noconfirm && pacman -S ruby git puppet xf86-video-vesa --noconfirm

# this must be the last statement because we need to reboot after initial installation
# so we autologin into the desktop environment
(cd /usr/etc/puppetfiles; bash papply.sh manifests/htpc.pp --verbose && reboot)
