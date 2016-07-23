#!/usr/bin/env sh
userdel terry	# remove image maintainer's user
puppet module install puppetlabs-vcsrepo
puppet module install maestrodev-wget
puppet module install saz-sudo
