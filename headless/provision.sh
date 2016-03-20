#!/usr/bin/env sh
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
