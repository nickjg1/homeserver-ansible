#!/bin/bash

if [ -z "$1" ]; then
  echo "No password supplied"
  exit 1
fi

if [ -z "$2" ]; then
  echo "No username supplied"
  exit 1
fi

cd /home/$2

if [ -e "ansible-nas" ]; then
  sudo rm -rf ansible-nas
fi

path=/home/$2/ansible-nas/inventories/my-ansible-nas/group_vars/nas.yml
path2=/home/$2/ansible-nas/inventories/my-ansible-nas/inventory

git clone https://github.com/davestephens/ansible-nas.git
cd ansible-nas
cp -rfp inventories/sample inventories/my-ansible-nas
sed -i '$ d' $path
sed -i '$ d' $path
echo "dashy_enabled: true" >> $path
echo "bazarr_enabled: true" >> $path
echo "couchpotato_enabled: true" >> $path
echo "pyload_enabled: true" >> $path
echo "minecraft_server_enabled: true" >> $path
echo "homeassistant_enabled: true" >> $path
echo "homeassistant_available_externally: true" >> $path
echo "plex_enabled: true" >> $path
echo "firefly_enabled: true" >> $path
echo "piwigo_enabled: true" >> $path
echo "traefik_enabled: true" >> $path
echo "duplicati_enabled: true" >> $path
echo "watchtower_enabled: true" >> $path
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
echo "$expect_script" > expect_script.exp
chmod +x expect_script.exp
./expect_script.exp "$1"

rm expect_script.exp