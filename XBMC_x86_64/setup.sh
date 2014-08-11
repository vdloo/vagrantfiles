#!/bin/bash
sudo apt-get -y install git libxslt1-dev libssh-dev swig swig2.0 openjdk-7-jdk xinit x11-xserver-utils
sudo apt-get -y build-dep xbmc
git clone git://github.com/xbmc/xbmc.git
make -C xbmc/lib/taglib
sudo make -C xbmc/lib/taglib install
(cd xbmc; ./bootstrap; ./configure; make && make install)

#autologin as user vagrant in gui
sed -i '$ d' /etc/init/tty1.conf; echo "exec /bin/login -f vagrant < /dev/tty1 > /dev/tty1 2>&1" >> /etc/init/tty1.conf
