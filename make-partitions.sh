#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## Helper script to partition a pendrive
LFS_DISK=${LFS_DISK:-/dev/sdb}

# Show currently mounted system
log "This is the disk on ${LFS_DISK}"
sudo fdisk -l ${LFS_DISK}
log "Create new partition?"
log "Continue? [y/n]"
read response
while :;do
    case ${response} in
        y|Y)
            log continue
            break;;
        n|N)
            log stop
            exit 0;;
        \?)
            log Please answer either y or n.;;
    esac
done

# Here are the options this script will submit to fdisk
# - o:create partition table,
# - n:new-partition, p:primary _:default partition number 1, _:default start sector, +100M:100MB of size, a:bootable
# - n:new-partition, p:primary _:default partition number 2, _:default start sector, _:default size (full disk)
# - p:show partitions
# - w:save
sudo fdisk ${LFS_DISK} << EOF
o
n
p


+100M
a
n
p



p
w
EOF

# Creating the filesystem
sudo mkfs -v -t ext4 ${LFS_DISK}1
sudo mkfs -v -t ext4 ${LFS_DISK}2
