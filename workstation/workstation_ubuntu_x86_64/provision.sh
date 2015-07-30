#!/usr/bin/env sh

apt-get update -yy
apt-get -y install ruby git puppet virtualbox-guest-x11

#get puppet from git until the package groups patch is in official repo
git clone https://github.com/vdloo/puppet
(cd puppet; git checkout fix-pacman-membership-group-problem; ruby install.rb)

puppet module install puppetlabs-vcsrepo
puppet module install maestrodev-wget
puppet module install saz-sudo

mkdir -p code/configs -m 755
git clone https://github.com/vdloo/puppetfiles /usr/etc/puppetfiles
(cd /usr/etc/puppetfiles; bash papply.sh manifests/workstation.pp --verbose)

# This needs to happen outside of puppet because Vundle requires a tty to
# install :( see: https://github.com/gmarik/Vundle.vim/issues/511
#su vdloo -c vim +PluginInstall +qall; printf "\033c"
reboot
