#!/bin/sh
type -p apt-get \
	&& apt-get -y update && apt-get -y install vim-nox git
type -p pacman \
	&& pacman --noconfirm -Syyu && pacman --noconfirm -S vim git
