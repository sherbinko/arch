set ARCH_ISO=T:/archlinux-2018.09.01-x86_64.iso

"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createmedium disk --size 20480 --format VMDK --variant Fixed --filename C:/VMs/Arch/Main.vmdk
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createmedium disk --size 100 --format VDI --variant Fixed --filename C:/VMs/Arch/EFI.vdi
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createvm --name="Arch" --ostype ArchLinux_64 --register
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" sharedfolder add Arch --name "common" --hostpath "C:/VMs/Common"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm Arch --memory 8192 --vram 128 --cpus 4
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm Arch --firmware efi64 --rtcuseutc on
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm Arch --mouse usb --audio dsound --audioout on --audioin on
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm Arch --nic1 bridged --nicpromisc1 allow-all --bridgeadapter1 "Killer Wireless-n/a/ac 1535 Wireless Network Adapter" --nictype1 82545EM
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm Arch --accelerate3d on
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storagectl Arch --add ide --name IDE
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storagectl Arch --add pcie --name NVMe
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storagectl Arch --add sata --portcount 1 --name SATA
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach Arch --storagectl IDE --port 0 --device 0 --type dvddrive --medium %ARCH_ISO%
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach Arch --storagectl NVMe --port 0 --device 0 --type hdd --nonrotational on --medium "C:/VMs/Arch/Main.vmdk"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach Arch --storagectl SATA --port 0 --device 0 --type hdd --medium "C:/VMs/Arch/EFI.vdi"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm Arch --type gui
