#!/bin/sh


#example ./retrieve.sh -p 1234 -u vdloo -h example.com

PORT=22
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

#check if there are arguments
if [ $USER ] && [ $REMOTEHOST ]; then
	#make the ssh agent forward available for root during provisioning
	SSH_FIX_FILE="/etc/sudoers.d/root_ssh_agent"
	if [ ! -f  $SSH_FIX_FILE ]; then
		echo "Defaults env_keep += \"SSH_AUTH_SOCK\"" > $SSH_FIX_FILE
		chmod 0440 $SSH_FIX_FILE
	fi
	su vagrant -c "ssh-keyscan -p $PORT $REMOTEHOST >> ~/.ssh/known_hosts"
	su vagrant -c "git clone ssh://$USER@$REMOTEHOST:$PORT/~/repo/dotfiles/dotfiles.git && (rm ~/.bashrc && find dotfiles/ -mindepth 1 -maxdepth 1 ! -name '.git' -exec ln -s {} ~ ';') || (cp /vagrant/retrieve.sh ~; echo 'host system ssh agent not accepted, try manually running ./retrieve.sh')"
fi
