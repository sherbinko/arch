#!/usr/bin/env bash
yes|mkfs -t ext4 /dev/nvme0n1
parted -s /dev/sda mktable gpt mkpart ESP fat32 2048s 100% set 1 boot on
yes|mkfs /dev/sda1 -t fat
mkdir /mnt/nvme
mount /dev/nvme0n1 /mnt/nvme
