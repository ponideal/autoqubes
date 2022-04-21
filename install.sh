#!/bin/bash

WORK_DIR="/home/user/autoqubes"

ANSIBLE_CONFIG_ENV_DIR="$WORK_DIR/ansible-qubes/ansible.cfg"
ANSIBLE_ROOT_DIR="/etc/ansible"
ANSIBLE_NET_VM="sys-firewall"

RPCDIR="/etc/qubes-rpc"
NAME_BOBMSHELL_CLIENT="controller"
BASED_VM="fedora-34"


#update dom0
#sudo qubes-dom0-update --clean -y

#create controller VM - clone BASEDVM
qvm-clone "$BASED_VM" "$NAME_BOBMSHELL_CLIENT" -v

#update BOBBSHELL client and BASED VM
#sudo qubes-dom0-update --action=upgrade "qubes-template-$NAME_BOBMSHELL_CLIENT"
#sudo qubes-dom0-update --action=upgrade "qubes-template-$BASED_VM"

#active service in dom0
sudo touch "$RPCDIR/qubes.VMShell"
sudo chmod 0644 "$RPCDIR/qubes.VMShell"
sudo echo "exec bash" > "$RPCDIR/qubes.VMShell"
sudo cat "$RPCDIR/qubes.VMShell"

#policy allow for controller/manager
sudo touch "$RPCDIR/policy/qubes.VMShell"
sudo chmod 0664 "$RPCDIR/policy/qubes.VMShell"
sudo echo "$NAME_BOBMSHELL_CLIENT dom0 allow" > "$RPCDIR/policy/qubes.VMShell"
sudo echo "$NAME_BOBMSHELL_CLIENT @anyvm allow" >> "$RPCDIR/policy/qubes.VMShell"
sudo cat "$RPCDIR/policy/qubes.VMShell"

#install git and ansible
sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" 'sudo dnf install git ansible nano -y'

#set nevm in BOBMSHELL client
sudo qvm-prefs "$NAME_BOBMSHELL_CLIENT" netvm "$ANSIBLE_NET_VM"


sudo qvm-shutdown "$BASED_VM" --wait
sudo qvm-shutdown "$NAME_BOBMSHELL_CLIENT" --wait

sudo qvm-start "$NAME_BOBMSHELL_CLIENT"

#remove dir
sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" "sudo rm -rf $WORK_DIR"

#install ansible-qubes GIT
sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" "git clone https://github.com/ponideal/autoqubes.git"

#transfer confuguration in controller
#sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" "sudo rm -rf $ANSIBLE_ROOT_DIR/"

#transef ansible cfg 
sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" "sudo cp -rf $WORK_DIR/ansible-qubes/ansible.cfg $ANSIBLE_ROOT_DIR/ansible.cfg"

#transef host file
sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" "sudo cp -rf $WORK_DIR/ansible-qubes/hosts $ANSIBLE_ROOT_DIR/hosts"

#ping test to dom0
sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" "ansible dom0 -m ping"


#sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" "xterm"
#sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" "nautilus"







#sudo touch /etc/bash.profile
#sudo chmod 755 /etc/bash.profile
#sudo echo "export ANSIBLE_CONFIG='$ANSIBLE_CONFIG_ENV_DIR'" > /etc/bash.profile


