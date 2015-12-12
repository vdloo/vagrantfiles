#!/usr/bin/env sh
pacman -Syyu --noconfirm && pacman -S git puppet acl --noconfirm
(cd /usr/etc/puppetfiles; bash papply.sh manifests/workstation.pp --verbose)
