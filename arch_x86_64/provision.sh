#!/usr/bin/env sh
pacman -Syyu --noconfirm && pacman -S git puppet --noconfirm
puppet module install puppetlabs-vcsrepo
puppet module install maestrodev-wget

mkdir -p code/configs -m 755
git clone https://github.com/vdloo/puppetfiles /usr/etc/puppetfiles
(cd /usr/etc/puppetfiles; bash papply.sh manifests/headless.pp --verbose)

# This needs to happen outside of puppet because Vundle requires a tty to
# install :( see: https://github.com/gmarik/Vundle.vim/issues/511
su vdloo -c vim +PluginInstall +qall && printf "\033c"

echo "sudo su vdloo -c 'cd $HOME; bash" > /home/vagrant/.bashrc
