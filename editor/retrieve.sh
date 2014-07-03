#!/bin/sh
#example ./retrieve.sh -p 1234 -u vdloo -h example.com

unset USER
unset REMOTEHOST
while getopts ":p:u:h:" opt; do
	case "$opt" in
		p)
			PORT="$OPTARG" ;;
		u)
			USER="$OPTARG" ;;
		h)
			REMOTEHOST="$OPTARG" ;;
	esac
done
if [ "$PORT" = "-h" ] || [ "$PORT" = '-u' ]; then
	PORT=22
fi
[ ! -t 0 ] && cp /vagrant/retrieve.sh /home/vagrant/
if [ "$USER" != "-p" ] && [ "$USER" != '-u' ] && [ "$USER" != '-h' ] && [ "$REMOTEHOST" != "-p" ] && [ "$REMOTEHOST" != '-u' ] && [ "$REMOTEHOST" != '-h' ]; then
	if [ "$(id -u)" != "0" ]; then
		ssh-keygen -b 4096 -f ~/.ssh/id_rsa -t rsa -N '' && ssh-copy-id "$USER@$REMOTEHOST -p $PORT"
		git clone ssh://$USER@$REMOTEHOST:$PORT/~/repo/dotfiles.git && (
			rm ~/.bashrc && find dotfiles/ -mindepth 1 -maxdepth 1 ! -name '.git' -exec ln -s {} ~ ';'
			. ~/.repostrap.sh
			. ~/.bashrc
		)
	else
		#make the ssh agent forward available for root during provisioning
		SSH_FIX_FILE="/etc/sudoers.d/root_ssh_agent"
		if [ ! -f  $SSH_FIX_FILE ]; then
			echo "Defaults env_keep += \"SSH_AUTH_SOCK\"" > $SSH_FIX_FILE
			chmod 0440 $SSH_FIX_FILE
		fi
		su vagrant -c "ssh-keyscan -p $PORT $REMOTEHOST >> ~/.ssh/known_hosts"
		su vagrant -c "git clone ssh://$USER@$REMOTEHOST:$PORT/~/repo/dotfiles.git && (rm ~/.bashrc && find dotfiles/ -mindepth 1 -maxdepth 1 ! -name '.git' -exec ln -s {} ~ ';'; . ~/.repostrap.sh) || echo 'host system ssh agent not accepted, try manually running ./retrieve.sh'"
	fi
else 
	[ ! -t 0 ] && echo 'no remote host specified, manually run the retrieve.sh script from within the vm'
fi
