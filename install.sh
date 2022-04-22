#!/bin/bash

WORK_DIR="/home/user/autoqubes"

ANSIBLE_ROOT_DIR="/etc/ansible"
ANSIBLE_NET_VM="sys-firewall"

RPCDIR="/etc/qubes-rpc"
NAME_BOBMSHELL_CLIENT="controller"
BASED_VM="fedora-34-clone"

#update dom0
#sudo qubes-dom0-update --clean -y

#create controller VM - clone BASEDVM
#qvm-clone "$BASED_VM" "$NAME_BOBMSHELL_CLIENT-TEMPLATE" -v

#qvm create 
qvm-create --prop template=$BASED_VM --prop name=$NAME_BOBMSHELL_CLIENT --label=red
#update BOBBSHELL client and BASED VM
#sudo qubes-dom0-update --action=upgrade "qubes-template-$NAME_BOBMSHELL_CLIENT"
#sudo qubes-dom0-update --action=upgrade "qubes-template-$BASED_VM"

#active service in dom0
sudo rm -rf "$RPCDIR/qubes.VMShell"
sudo touch "$RPCDIR/qubes.VMShell"
sudo chmod 0644 "$RPCDIR/qubes.VMShell"
sudo echo "exec bash" > "$RPCDIR/qubes.VMShell"
sudo cat "$RPCDIR/qubes.VMShell"

#policy allow for controller/manager
sudo rm -rf "$RPCDIR/policy/qubes.VMShell"
sudo touch "$RPCDIR/policy/qubes.VMShell"
sudo chmod 0664 "$RPCDIR/policy/qubes.VMShell"
sudo echo "$NAME_BOBMSHELL_CLIENT dom0 allow" > "$RPCDIR/policy/qubes.VMShell"
sudo echo "$NAME_BOBMSHELL_CLIENT @anyvm allow" >> "$RPCDIR/policy/qubes.VMShell"
sudo echo "$NAME_BOBMSHELL_CLIENT fedrora34-ProxyWork allow" >> "$RPCDIR/policy/qubes.VMShell"
sudo cat "$RPCDIR/policy/qubes.VMShell"

#install git and ansible in tamplateVM
sudo qvm-run --pass-io "$BASED_VM" 'sudo dnf install git ansible nano -y'
sudo qvm-shutdown "$BASED_VM" --wait
sudo qvm-start "$BASED_VM"



#set nevm in BOBMSHELL client
sudo qvm-prefs "$NAME_BOBMSHELL_CLIENT" netvm "$ANSIBLE_NET_VM"


#install git and ansible in APPVM
sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" 'sudo dnf install git ansible nano -y'


sudo qvm-shutdown "$BASED_VM" --wait
sudo qvm-shutdown "$NAME_BOBMSHELL_CLIENT" --wait

sudo qvm-start "$NAME_BOBMSHELL_CLIENT"

#install ansible-qubes GIT
sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" "sudo rm -rf $WORK_DIR"
sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" "git clone https://github.com/ponideal/autoqubes.git"

sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" "chmod +x $WORK_DIR/controller_install.sh"
sudo qvm-run --pass-io "$NAME_BOBMSHELL_CLIENT" "sudo $WORK_DIR/controller_install.sh"


#sudo touch /etc/bash.profile
#sudo chmod 755 /etc/bash.profile
#sudo echo "export ANSIBLE_CONFIG='$ANSIBLE_CONFIG_ENV_DIR'" > /etc/bash.profile


