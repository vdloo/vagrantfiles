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

NONROOT_USER=$(id -u vdloo 2>&1> /dev/null && echo 'vdloo' || echo 'nonroot')
echo "setfacl -m $NONROOT_USER:x \$(dirname \"\$SSH_AUTH_SOCK\")" >> /home/vagrant/.bashrc
echo "setfacl -m $NONROOT_USER:rwx \"\$SSH_AUTH_SOCK\"" >> /home/vagrant/.bashrc
echo "sudo su $NONROOT_USER -l -c \"export SSH_AUTH_SOCK=\$SSH_AUTH_SOCK; bash\"" >> /home/vagrant/.bashrc
