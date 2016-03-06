#!/usr/bin/env sh
userdel terry	# remove image maintainer's user
pacman -Syyu --noconfirm && pacman -S git puppet xf86-video-vesa --noconfirm
(cd /usr/etc/puppetfiles; bash papply.sh manifests/htpc.pp --verbose)
