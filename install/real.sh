#!/usr/bin/env bash
cp /root/install/70-keyboard.hwdb /etc/udev/hwdb.d
udevadm hwdb --update

netctl disable bridged
netctl enable wifi

systemctl disable vboxservice
systemctl disable sshd