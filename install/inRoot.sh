#!/bin/sh

yes|pacman -S terminus-font iw wpa_supplicant wpa_actiond dialog efibootmgr net-tools openssh ntfs-3g grub xf86-input-evdev nvidia-utils libglvnd virtualbox-guest-modules-arch virtualbox-guest-utils sudo exfat-utils

cp /root/install/fstab /etc/fstab

ln -s -f /usr/share/zoneinfo/Australia/Sydney /etc/localtime
hwclock --systohc --utc
sed -i -e '/^#\(ru_RU\.UTF-8\|en_AU\.UTF-8\|en_US\.UTF-8\)/s/^#//' /etc/locale.gen
locale-gen
cp /root/install/locale.conf /etc/locale.conf
echo arch >/etc/    hostname
cp /root/install/vconsole.conf /etc/vconsole.conf

rm -r /boot/grub
mkdir /mnt/efi
mount /dev/sda1 /mnt/efi
grub-install --target=x86_64-efi --efi-directory=/mnt/efi --bootloader-id=grub --boot-directory=/mnt/efi/EFI
mkdir /mnt/efi/EFI/boot
cp /mnt/efi/EFI/grub/grubx64.efi /mnt/efi/EFI/boot/bootx64.efi
cp /root/install/grub.cfg /etc/grub.d/40_custom
grub-mkconfig -o /mnt/efi/EFI/grub/grub.cfg

cp /root/install/bridged /etc/netctl/bridged
netctl enable bridged
cp /root/install/wifi /etc/netctl/wifi

systemctl enable vboxservice
gpasswd -a root vboxsf
mkdir /mnt/common

sed -i -e '/^#\?ListenAddress 0\.0\.0\.0/s/.*/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config
sed -i -e '/^#\?PermitRootLogin .*/s/.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i -e '/^#\?PasswordAuthentication .*/s/.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i -e '/^#\?PubkeyAuthentication .*/s/.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i -e '/^#\?X11Forwarding .*/s/.*/X11Forwarding yes/' /etc/ssh/sshd_config
sed -i -e '/^#\?X11DisplayOffset .*/s/.*/X11DisplayOffset 0/' /etc/ssh/sshd_config
sed -i -e '/^#\?X11UseLocalhost .*/s/.*/X11UseLocalhost no/' /etc/ssh/sshd_config
mkdir /root/.ssh
cp /root/install/id_rsa.pub /root/.ssh/authorized_keys
systemctl enable sshd

cp /root/install/mount /usr/lib/initcpio/hooks/mount
cp /root/install/mount.sh /usr/lib/initcpio/install/mount
mkinitcpio -A mount -k `pacman -Qi linux|grep -Po "(?<=Version         : ).*(?=\.arch1)"`-arch1-1-ARCH -g /boot/custom.img

useradd -g root -m me
passwd -d me
cp /root/install/10-me /etc/sudoers.d
sudo -u me mkdir /home/me/aur

#################################################### GUI ###############################################################
yes|pacman -S xorg-server lxdm cinnamon
systemctl enable lxdm
cp /root/install/lxdm.conf /etc/lxdm/lxdm.conf

#################################################### System Addons #####################################################
echo '[multilib]' >>/etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >>/etc/pacman.conf
yes|pacman -Syu
yes ''|pacman -S --needed base-devel
yes|pacman -S ttf-dejavu artwiz-fonts libreoffice-fresh libx264 vlc phonon-qt5-vlc konsole krusader chromium git lib32-libglvnd kate wine wine_gecko wine-mono winetricks android-tools

cd /home/me/aur
sudo -u me git clone https://aur.archlinux.org/aurget.git
cd aurget
sudo -u me makepkg -sr
yes|pacman -U *.tar.xz

###################################################### Java ###############################################
cd /home/me/aur
sudo -u me git clone https://aur.archlinux.org/jdk9.git
cd jdk9
yes|sudo -u me makepkg -sr
yes|pacman -U *.tar.xz

cd /home/me/aur
sudo -u me git clone https://aur.archlinux.org/intellij-idea-ultimate-edition.git
cd intellij-idea-ultimate-edition
yes|sudo -u me makepkg -sr
yes|pacman -U *.tar.xz

yes|pacman -S maven gradle kotlin

###################################################### Exit ###############################################
exit