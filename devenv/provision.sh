#!/usr/bin/env sh
apt-get install git puppet -y
puppet module install puppetlabs-vcsrepo
puppet module install maestrodev-wget

mkdir -p code/configs -m 755
git clone git@github.com:vdloo/puppetfiles.git code/configs/puppetfiles 2> /dev/null
(cd code/configs/puppetfiles; bash manifests/headless.pp --verbose)

# This needs to happen outside of puppet because Vundle requires a tty to
# install :( see: https://github.com/gmarik/Vundle.vim/issues/511
su vdloo -c vim +PluginInstall +qall; printf "\033c"

echo 'sudo su vdloo' > /home/vagrant/.bashrc
