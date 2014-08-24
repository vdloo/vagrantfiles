#!/bin/bash
# The official coreos-vagrant repo vagrantfile doesn't have support for vagrant-kvm.
# This script clones that repo and converts the VirtualBox image with vagrant-mutate
# to create a kvm box. Then using sed a section is added to the Vagrantfile so a
# a kvm instance of CoreOS can be started with the command 'vagrant --provider=kvm up'
[ ! -d coreos-vagrant ] \
	&& git clone https://github.com/coreos/coreos-vagrant \
	|| (cd coreos-vagrant; git pull)
cd coreos-vagrant
JSONURL=$(cat Vagrantfile | grep "config.vm.box_url" | cut -d'"' -f2)
CHANNEL=$(cat Vagrantfile | grep "update_channel" | head -n 1 | cut -d'"' -f2)
JSONURL=$(echo $JSONURL | sed "s/\%s/$CHANNEL/g")
BOXURL=$(curl -s $JSONURL | grep url | cut -d'"' -f4)
[ ! -f  coreos_production_vagrant.box ] \
	&& wget http://alpha.release.core-os.net/amd64-usr/410.0.0/coreos_production_vagrant.box
vagrant mutate coreos*.box kvm
sed -i 's/# plugin conflict/config.vm.provider :kvm do |vb, override|\n\toverride.vm.box = "coreos_production_vagrant"\n\toverride.vm.box_version = "0"\n\tconfig.ssh.username="core"\n  end\n\n# plugin conflict/g' Vagrantfile

