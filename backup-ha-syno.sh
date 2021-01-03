#!/bin/bash
remote_share="//192.168.1.xxx/hassio"
remote_mounted_share="/home/xxx/xxx/snapshot/"
local_dir="/usr/share/hassio/backup/"
username="xxxx"
password="xxxx"

# your settings
echo -e "\e[0m=============================================="
echo -e "Your actual settings:"
echo -e "\e[0m=============================================="
echo -e "\e[36mRemote share: \e[0m$remote_share"
echo -e "\e[36mRemote_mounted_share: \e[0m$remote_mounted_share"
echo -e "\e[36mLocal_dir: \e[0m$local_dir"
echo -e "\e[36mUsername: \e[0m$username"
echo -e "\e[36mPassword: \e[0m$password"
echo -e "\e[0m=============================================="


if [ ! -d "/home/sky/Documents/snapshot/" ]
then
    
    sudo mount -t cifs -o username=xxxx,password=xxxx //192.168.1.xxx/hassio /home/xxx/xxx
    echo -e "\e[0mMounting remote share: $remote_share"
else
echo -e "\e[0m=============================================="
 
sleep 1
echo -e ""
echo -e "\e[32mShared Folder \e[0m$remote_share \e[32m is already mounted!"
echo -e
sleep 3 
fi

echo -e "\e[0m=============================================="
echo -e ""
echo -e "\e[0mLooking for Last Backup to transfert......"
sleep 1
last_backup=$(cd /usr/share/hassio/backup/ && ls *.tar -1t | head -1 )
last_backup_nas=$(cd /home/xxx/xxxx/snapshot/ && ls *.tar -1t | head -1 )
echo -e ""
sleep 1
echo -e "\e[32mLast backup local is: \e[0m" $last_backup
echo -e "\e[36mLast backup on nas is: \e[0m" $last_backup_nas

sleep 3

cd /home/xxx/xxxx/snapshot
if [ ! -f "$last_backup" ]
then
	
    echo -e "$last_backup does not exist."
    echo -e "\e[32mTransfering to Nas $last_backup..."
    sudo rsync -ah --progress --ignore-existing /usr/share/hassio/backup/$last_backup /home/xxx/xxxx/snapshot/$last_backup
    sleep 2
else
echo -e "" 
echo -e "\e[0m$last_backup_nas \e[32m exists on remote folder, No transfert necessary."
sleep 2
echo -e ""
fi

echo -e "\e[0m=============================================="
echo -e "Checking md5sum..."
echo -e ""
sum_1=$(cd /usr/share/hassio/backup/ && md5sum $last_backup | tee $last_backup.md5 )
sum_11=$(cd /usr/share/hassio/backup/ && md5sum $last_backup )

echo -e "Local file: $sum_11"
echo -e ""

sum_0=$(cd /home/sky/Documents/snapshot && md5sum $last_backup)
echo -e "Remote file: $sum_0"

sudo rsync -a --human-readable /usr/share/hassio/backup/$last_backup.md5 /home/xxx/xxxx/snapshot/$last_backup.md5
cd /home/sky/Documents/snapshot
echo -e "comparing the md5sum"
md5_compare=$(md5sum -c $last_backup.md5)
echo -e "Result: $md5_compare"