#!/bin/sh
sudo systemctl enable sshd
sudo systemctl enable vboxservice

sudo netctl disable wifi
sudo netctl enable bridged