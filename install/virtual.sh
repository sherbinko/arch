#!/usr/bin/env bash
systemctl enable sshd
systemctl enable vboxservice

netctl disable wifi
netctl enable bridged

rm /etc/udev/hwdb.d/70-keyboard.hwdb
udevadm hwdb --update
