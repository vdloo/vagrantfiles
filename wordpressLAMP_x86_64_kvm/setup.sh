#!/bin/bash
type -p apt-get \
	&& apt-get -y update && apt-get -y upgrade && apt-get -y install vim-nox git wordpress mysql-server apache2 php5 libapache2-mod-php5 htop screen php5-cli
#type -p pacman \
#	&& pacman --noconfirm -Syyu && pacman --noconfirm -S vim git
ln -s /usr/share/wordpress /var/www/html/wordpress
gzip -d /usr/share/doc/wordpress/examples/setup-mysql.gz
bash /usr/share/doc/wordpress/examples/setup-mysql -n wordpress localhost
chown -R www-data /usr/share/wordpress
