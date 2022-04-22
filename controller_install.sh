#!/bin/bash

WORK_DIR="/home/user/autoqubes"
HOME_DIR="/home/user"
ANSIBLE_ROOT_DIR="/etc/ansible"
BASH_RC_PATH="$HOME_DIR/.bashrc"
QRUN_PATH="/home/user/ansible-qubes/bin"


#transfer confuguration in controller
#sudo rm -rf $ANSIBLE_ROOT_DIR/

#transef ansible cfg 
sudo cp -rf $WORK_DIR/ansible-qubes/ansible.cfg $ANSIBLE_ROOT_DIR/ansible.cfg

#transef host file
sudo cp -rf $WORK_DIR/ansible-qubes/hosts $ANSIBLE_ROOT_DIR/hosts

#create PATH for qrun, bombshell
if grep -q $QRUN_PATH $BASH_RC_PATH
	then echo "PATH $QRUN_PATH in $BASH_RC_PATH file is exist!"
else 
	sudo echo "export PATH=\$PATH:$QRUN_PATH" >> $BASH_RC_PATH
	echo "PATH $QRUN_PATH in $BASH_RC_PATH DONE!"
fi

#ping test to dom0
ansible dom0 -m ping
