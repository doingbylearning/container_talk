#!/usr/bin/env bash

sudo pacman -Sy cowsay
wget https://github.com/ericchiang/containers-from-scratch/releases/download/v0.1.0/rootfs.tar.gz
sudo tar -zxf rootfs.tar.gz
sudo cp /dev/urandom rootfs/dev/urandom
export PATH="/bin:/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin"
