#!/bin/bash


if [ -z "$1" ]; then
  echo "No username supplied"
  exit 1
fi

cd /home/$1/ansible-nas

path=/home/$1/ansible-nas/inventories/my-ansible-nas/group_vars/nas.yml
path2=/home/$1/ansible-nas/inventories/my-ansible-nas/inventory

sed -i '$ d' $path
sed -i '$ d' $path
sed -i '$ d' $path2
echo "ansible-nas ansible_connection=local ansible_host=localhost" >> $path2
ansible-galaxy install -r requirements.yml

