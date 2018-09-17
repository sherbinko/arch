#!/bin/sh

mkdir /mnt/nvme
mount /dev/nvme0n1 /mnt/nvme
timedatectl set-ntp true

yes|pacman -Sy pacman-contrib
curl -s "https://www.archlinux.org/mirrorlist/?country=AU&country=CN&country=NC&country=NZ&country=SG&country=US&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 6 - >/etc/pacman.d/mirrorlist
pacstrap /mnt/nvme base
cp /etc/pacman.d/mirrorlist /mnt/nvme/etc/pacman.d/mirrorlist
genfstab -p /mnt/nvme >/mnt/nvme/etc/fstab
cp -r /root/install /mnt/nvme/root
arch-chroot /mnt/nvme /root/install/inRoot.sh
halt -p

#todo microsoft fonts, fix software rendering, some aur helpers, fix writing to host FS