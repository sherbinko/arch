set PUBKEY_LOCATION=%USERPROFILE%\.ssh\id_rsa.pub

set /P PUBKEY=<"%PUBKEY_LOCATION%"

"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm Arch keyboardputstring ifconfig enp0s17 192.168.0.13 netmask 255.255.255.0 up
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm Arch keyboardputscancode 1c 9c
sleep 1

"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm Arch keyboardputstring ip link set enp0s17 down
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm Arch keyboardputscancode 1c 9c
sleep 1

"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm Arch keyboardputstring ip link set enp0s17 up
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm Arch keyboardputscancode 1c 9c
sleep 10

"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm Arch keyboardputstring "mkdir /root/.ssh"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm Arch keyboardputscancode 1c 9c
sleep 1

"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm Arch keyboardputstring "echo '%PUBKEY%' >/root/.ssh/authorized_keys"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm Arch keyboardputscancode 1c 9c
sleep 1

"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm Arch keyboardputstring systemctl start sshd
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm Arch keyboardputscancode 1c 9c
sleep 1

ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@arch bash -- <prepareFS.sh
scp -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -r install root@arch:/mnt/nvme
scp -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -r /cygdrive/c/Windows/Fonts root@arch:/mnt/nvme/install
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@arch bash -- <install.sh

sleep 10
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach Arch --storagectl IDE --port 0 --device 0 --type dvddrive --medium none
