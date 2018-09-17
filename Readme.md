# Introduction
The project represents scripts for installation of [Arch Linux](https://www.archlinux.org) into Virtual Box on Windows 10 host.  
Installed Linux can be booted directly on your hardware as well.  
No partition modifications are required. Linux will be booted from a file on your NTFS disk.    
The scripts are supposed to run on **MSI GS73VR 7RF Stealth Pro with 4K screen and Samsung 960 PRO NVMe** but it should work on other hardware after minor modifications.    
Location - Sydney, Australia. Russian Language and locale will be installed  

#Prerequisites
0. Your are connected to Internet through Wi-Fi
0. Secure boot is disabled
0. Windows and Virtual Box installation are located on NVMe drive and you have **20G** of free space. Set label of that partition to **windows** (critical if you want to boot from UEFI)
0. [Virtual Box](https://www.virtualbox.org) is installed
0. Your Virtual Box Machines location is configured as **C:/VMs**. Create **C:/VMs/Common** which will be used as a shared directory.  
0. [Cygwin](https://www.cygwin.com) is installed and its binaries are available through PATH. Install **openssh** in Cygwin.
0. SSH keys have been generated on your host
0. Your **hosts** file contains mapping from **arch** to **192.168.0.13**
0. Tell Windows to use UTC time in your UEFI. Run the **utctime.reg** file
0. Arch Linux installation iso is downloaded. 

#Configuration
0. Set Arch iso location (**ARCH_ISO**) in the **createVM.cmd** file
0. Set your SSH public key location (**PUBKEY_LOCATION**) in the **install.cmd** file
0. Set your Wi-Fi network name (**ESSID**) and password (**KEY**) in the **install/wifi** file

#Installation
0. Go to the **arch** directory
0. Run **createVM.cmd** and wait until a new Virtual Machine is created and started. Do not type anything in the VM window.
0. Run **install.cmd** and wait until it completes and the virtual machine shuts down.
0. Open the **C:/VMs/Arch/EFI.vdi** hard disk image with Far Manager or 7-zip and copy the **EFI/grub** directory to your **EFI** directory on the EFI partition (use **diskpart** or **mountvol** to mount in Windows). Do not override or remove anything!
0. Your UEFI should see the Grub loader now. Set it as the default boot option 

# Usage
* Arch Linux with Cinnamon is installed into a plain file and can be booted both from UEFI (native mode) and Virtual Box.  
* The host partition is mounted in **/host**  
* To switch between native and Virtual Box modes run **/root/install/real.sh** and **/root/install/virtual.sh**    
* GS73VR 7RF misses some important keys so the native mode script remaps few numpad keys:
* NumPad->Home
    * 7->Page Up
    * 4->Page Down
    * 1->End
    * PgDown->Volume Up        
    * PgUp->Volume Down
    * Other numpad keys except Insert and Delete are disabled       