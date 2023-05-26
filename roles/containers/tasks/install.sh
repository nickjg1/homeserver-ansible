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

#Creates expect script to run ansible-playbook with password
expect_script=$(cat << 'EOD'
#!/usr/bin/expect -f
set password [lindex $argv 0]
spawn ansible-playbook -i inventories/my-ansible-nas/inventory nas.yml -b -K
expect "BECOME password:"
send "$password\r"
interact
EOD
)
cd /home/$1/ansible-nas
sudo echo "$expect_script" > expect_script.exp
sudo chmod +x expect_script.exp

