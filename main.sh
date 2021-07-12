#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -e
export LFS=/mnt/lfs
export LFS_DISK=/dev/sdb

function ask() {
    # ask for user consent before executing the command
    CMD=$@
    echo "[+] exec ${CMD} ? [ENTER/Ctrl-C]"
    read
    ${CMD}
}

if ! mount | grep ${LFS} >/dev/null; then
    echo [+] mounting ${LFS}
    ask sudo mount -v -t ext4 ${LFS_DISK}2 ${LFS}
fi


