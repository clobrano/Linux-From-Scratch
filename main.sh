#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
set -e
export LFS=/mnt/lfs
export LFS_DISK=/dev/sdb
export LFS_TGT=x86_64-lfs-linux-gnu

function log() {
    echo [+] $@
}

function err() {
    echo [!] $@
}

function ask() {
    # ask for user consent before executing the command
    CMD=$@
    log "exec ${CMD} ? [ENTER/Ctrl-C]"
    #${CMD}
}

export -f log
export -f err
export -f ask

if ! mount | grep ${LFS} >/dev/null; then
    log mounting ${LFS}
    ask sudo mount -v -t ext4 ${LFS_DISK}2 ${LFS}
fi

#source packages.sh
source compile.sh stage1 binutils 
