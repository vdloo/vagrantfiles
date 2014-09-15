#!/bin/bash
type -p apt-get \
	&& apt-get -y update && apt-get -y install vim-nox git wordpress mysql-server apache2
#type -p pacman \
#	&& pacman --noconfirm -Syyu && pacman --noconfirm -S vim git
