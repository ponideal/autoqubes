#!/bin/bash

WORK_DIR="/home/user/autoqubes"
ANSIBLE_CONFIG_ENV_DIR="$WORK_DIR/ansible-qubes/ansible.cfg"

RPCDIR="/etc/qubes-rpc"
NAME_BOBMSHELL_CLIENT="controller"
BASED_VM="fedora-34"

ANSIBLE_NET_VM="sys-firewall"
ANSIBLE_ROOT_DIR="/etc/ansible"


sudo git clone https://github.com/ponideal/autoqubes.git

sudo rm -rf $ANSIBLE_ROOT_DIR/

sudo cp -f $ANSIBLE_CONFIG_ENV_DIR /etc/ansible/ansible.cfg

sudo cp -f $WORK_DIR/hosts $ANSIBLE_ROOT_DIR/hosts

sudo ansible dom0 -m ping
