#!/bin/sh
# todo fix software rendering, remove paste by middle key, fix writing to host FS
################################################## Install installer ###################################################
yes|pacman -Sy pacman-contrib
curl -s "https://www.archlinux.org/mirrorlist/?country=AU&country=CN&country=NC&country=NZ&country=SG&country=US&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 6 - >/etc/pacman.d/mirrorlist

pacstrap /mnt/nvme base

cp /etc/pacman.d/mirrorlist /mnt/nvme/etc/pacman.d/mirrorlist
cp /root/.ssh/authorized_keys /mnt/nvme/install/authorized_keys

arch-chroot /mnt/nvme /bin/bash

################################################## Base ################################################################
yes|pacman -S terminus-font iw wpa_supplicant dialog efibootmgr net-tools openssh ntfs-3g grub xf86-input-evdev nvidia-utils libglvnd virtualbox-guest-modules-arch virtualbox-guest-utils sudo exfat-utils

mv /install/fstab /etc/fstab

timedatectl set-ntp true
ln -s -f /usr/share/zoneinfo/Australia/Sydney /etc/localtime
hwclock --systohc --utc

sed -i -e '/^#\(ru_RU\.UTF-8\|en_AU\.UTF-8\|en_US\.UTF-8\)/s/^#//' /etc/locale.gen
locale-gen
mv /install/locale.conf /etc/locale.conf
echo arch >/etc/hostname
mv /install/vconsole.conf /etc/vconsole.conf

#################################### Boot ##############################################################################
rm -r /boot/grub
mkdir /mnt/efi
mount /dev/sda1 /mnt/efi
grub-install --target=x86_64-efi --efi-directory=/mnt/efi --bootloader-id=grub --boot-directory=/mnt/efi/EFI
mkdir /mnt/efi/EFI/boot
cp /mnt/efi/EFI/grub/grubx64.efi /mnt/efi/EFI/boot/bootx64.efi

mv /install/mount /usr/lib/initcpio/hooks/mount
mv /install/mount.sh /usr/lib/initcpio/install/mount
mv /install/grub.cfg /etc/grub.d/40_custom
grub-mkconfig -o /mnt/efi/EFI/grub/grub.cfg
mkinitcpio -A mount -k `pacman -Qi linux|grep -Po "(?<=Version         : ).*(?=\.arch1)"`-arch1-1-ARCH -g /boot/custom.img

#################################### Network ###########################################################################
mv /install/bridged /etc/netctl/bridged
netctl enable bridged
mv /install/wifi /etc/netctl/wifi

#################################### Virtual Box #######################################################################
systemctl enable vboxservice
gpasswd -a root vboxsf
mkdir /mnt/common

#################################### SSH ###############################################################################
sed -i -e '/^#\?ListenAddress 0\.0\.0\.0/s/.*/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config
sed -i -e '/^#\?PermitRootLogin .*/s/.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i -e '/^#\?PasswordAuthentication .*/s/.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i -e '/^#\?PubkeyAuthentication .*/s/.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i -e '/^#\?X11Forwarding .*/s/.*/X11Forwarding yes/' /etc/ssh/sshd_config
sed -i -e '/^#\?X11DisplayOffset .*/s/.*/X11DisplayOffset 0/' /etc/ssh/sshd_config
sed -i -e '/^#\?X11UseLocalhost .*/s/.*/X11UseLocalhost no/' /etc/ssh/sshd_config
mkdir /root/.ssh
mv /install/authorized_keys /root/.ssh/authorized_keys
systemctl enable sshd

#################################### Users #############################################################################
useradd -g root -m me
passwd -d me
mv /install/10-me /etc/sudoers.d
sudo -u me mkdir /home/me/aur

#################################### Real Mode #########################################################################
mv /install/real.sh /bin/realMode
mv /install/virtual.sh /bin/virtualMode
chmod a+x /bin/realMode /bin/virtualMode

mv /install/70-keyboard.hwdb /etc/udev/hwdb.d
udevadm hwdb --update

#################################################### GUI ###############################################################
yes ''|pacman -S xorg-server sddm phonon-qt5-vlc plasma cinnamon
systemctl enable sddm

#################################################### System Addons #####################################################
yes ''|pacman -S --needed base-devel
yes|pacman -S ttf-dejavu libreoffice-fresh libx264 vlc phonon-qt5-vlc konsole krusader chromium git kate android-tools

mv /install/Fonts /usr/share/fonts/WindowsFonts
chmod 755 /usr/share/fonts/WindowsFonts/*
fc-cache

##################################################### Exit #############################################################
exit
halt -p
