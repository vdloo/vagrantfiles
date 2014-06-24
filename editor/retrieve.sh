#!/bin/sh
#example ./retrieve.sh -p 1234 -u vdloo -h example.com

unset USER
unset REMOTEHOST
while getopts ":p:u:h:" opt; do
	case "$opt" in
		p)
			PORT="$OPTARG" 
			if [ "$PORT" == "-h" ] || [ "$PORT" == '-u' ]; then
				PORT=22
			fi
			;;
		u)
			USER="$OPTARG" ;;
		h)
			REMOTEHOST="$OPTARG" ;;
	esac
done

[ ! -t 0 ] && cp /vagrant/retrieve.sh /home/vagrant/

if [ "$USER" != "-p" ] && [ "$USER" != '-u' ] && [ "$USER" != '-h' ] && [ "$REMOTEHOST" != "-p" ] && [ "$REMOTEHOST" != '-u' ] && [ "$REMOTEHOST" != '-h' ]; then
	#make the ssh agent forward available for root during provisioning
	SSH_FIX_FILE="/etc/sudoers.d/root_ssh_agent"
	if [ ! -f  $SSH_FIX_FILE ]; then
		echo "Defaults env_keep += \"SSH_AUTH_SOCK\"" > $SSH_FIX_FILE
		chmod 0440 $SSH_FIX_FILE
	fi
	su vagrant -c "ssh-keyscan -p $PORT $REMOTEHOST >> ~/.ssh/known_hosts"
	if [ "$(id -u)" != "0" ]; then
		git clone ssh://$USER@$REMOTEHOST:$PORT/~/repo/dotfiles/dotfiles.git && (rm ~/.bashrc && find dotfiles/ -mindepth 1 -maxdepth 1 ! -name '.git' -exec ln -s {} ~ ';')
	else
		su vagrant -c "git clone ssh://$USER@$REMOTEHOST:$PORT/~/repo/dotfiles/dotfiles.git && (rm ~/.bashrc && find dotfiles/ -mindepth 1 -maxdepth 1 ! -name '.git' -exec ln -s {} ~ ';') || echo 'host system ssh agent not accepted, try manually running ./retrieve.sh'"
	fi
else 
	[ ! -t 0 ] && echo 'no remote host specified, manually run the retrieve.sh script from within the vm'
fi
