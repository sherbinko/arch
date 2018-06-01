# Introduction
The project represents scripts for installation of [Arch Linux](https://www.archlinux.org) into Virtual Box on Windows 10 host.  
Installed Linux can be booted directly on your hardware as well (if you have UEFI).  
No partition modifications are required. Linux will be booted from a file on your NTFS disk.    
The scripts are supposed to run on **MSI GS73VR 7RF Stealth Pro with 4K screen and Samsung 960 PRO NVMe** but they should work on other hardware after minor modifications.    
Russian Language and locale will be installed  

#Prerequisites
* Your are connected to Internet through Wi-Fi
* Windows and Virtual Box installation are located on NVMe drive and you have **20G** of free space. Set label of that partition to **windows** (critical if you want to boot from UEFI)
* [Virtual Box](https://www.virtualbox.org) is installed
* Your Virtual Box Machines location is configured as **C:/VMs**. Create **C:/VMs/Common** which will be used as a shared directory.  
* [Cygwin](https://www.cygwin.com) is installed and its binaries are available through PATH. Install **openssh** in Cygwin.
* SSH keys have been generated on your host
* Your **hosts** file contains mapping from **arch** to **192.168.0.13**
* Tell Windows to use UTC time in your UEFI. Run the **utctime.reg** file
* Arch Linux installation iso is downloaded. 

#Configuration
* Set Arch iso location (**ARCH_ISO**) in the **createVM.cmd** file
* Set your SSH public key location (**PUBKEY_LOCATION**) in the **install.cmd** file
* Set your Wi-Fi network name (**ESSID**) and password (**KEY**) in the **install/wifi** file

#Installation
* Go to the **arch** directory
* Run **createVM.cmd** and wait until new Virtual Machine is created and started. Do not type anything in the VM.
* Run **install.cmd**
* Shutdown the virtual machine
* After installation open the **C:/VMs/Arch/EFI.vdi** hard disk image with Far Manager or 7-zip and copy the **EFI** directory to your boot partition. **Do not override your existing EFI partition.**  
GS73VR 7RF does not seem to support booting from USB. Use [DriveDroid](https://play.google.com/store/apps/details?id=com.softwarebakery.drivedroid) to boot from your rooted Android or use the second or external hard drive.

# Usage
Arch Linux with Cinnamon is installed into a plain file and can be booted both from UEFI (native mode) and Virtual Box.  
The host partition is mounted in **/host**  
To switch between native and Virtual Box modes run **/root/install/real.sh** and **/root/install/virtual.sh**    
GS73VR 7RF misses some important keys so the native mode script remaps few numpad keys:
* NumPad->Home
* 7->Up
* 4->Down
* 1->End
* PgDown->Volume Up        
* PgUp->Volume Down
* Other numpad keys except Insert and Delete are disabled       