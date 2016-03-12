#!/usr/bin/env sh

# mount shared shared dir over /home so we don't run out of disk space
NONROOT_USER=$(id -u vdloo > /dev/null 2>&1 && echo 'vdloo' || echo 'nonroot')
mkdir -p "/vagrant/home/$NONROOT_USER"
mkdir -p "/home/$NONROOT_USER"
mount --bind "/vagrant/home/$NONROOT_USER" "/home/$NONROOT_USER"

puppet module install puppetlabs-vcsrepo
puppet module install maestrodev-wget
puppet module install saz-sudo

mkdir -p code/configs -m 755
git clone git@github.com:vdloo/hieradata.git /usr/etc/hieradata
git clone https://github.com/vdloo/puppetfiles /usr/etc/puppetfiles
(cd /usr/etc/puppetfiles; bash papply.sh manifests/headless.pp --verbose)

# This needs to happen outside of puppet because Vundle requires a tty to
# install :( see: https://github.com/gmarik/Vundle.vim/issues/511
#su vdloo -c vim +PluginInstall +qall; printf "\033c"
