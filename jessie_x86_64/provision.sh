#!/usr/bin/env sh
apt-get install git puppet -y
puppet module install puppetlabs-vcsrepo
puppet module install maestrodev-wget

mkdir -p code/configs -m 755
git clone https://github.com/vdloo/puppetfiles code/configs/puppetfiles
(cd code/configs/puppetfiles; bash papply.sh manifests/headless.pp --verbose)

# This needs to happen outside of puppet because Vundle requires a tty to
# install :( see: https://github.com/gmarik/Vundle.vim/issues/511
su vdloo -c vim +PluginInstall +qall; printf "\033c"

echo 'sudo su vdloo' > /home/vagrant/.bashrc