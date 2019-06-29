#!/bin/sh
sudo netctl disable bridged
sudo netctl enable wifi

sudo systemctl disable vboxservice
sudo systemctl disable sshd