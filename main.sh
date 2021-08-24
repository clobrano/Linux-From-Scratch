#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
export LFS=/mnt/lfs
export LFS_DISK=/dev/sdb
export LFS_TGT=x86_64-lfs-linux-gnu
export PATH=$LFS/tools/bin:$PATH
export CONFIG_SITE=$LFS/usr/share/config.site

compileonly=$1

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
    ${CMD}
}

export -f log
export -f err
export -f ask

if ! mount | grep ${LFS} >/dev/null; then
    source ./make-partitions.sh

    log "making mountpoint ${LFS}"
    sudo mkdir -pv ${LFS}

    log "mounting ${LFS_DISK}2 on ${LFS}"
    ask "sudo mount -v -t ext4 ${LFS_DISK}2 ${LFS}"
    sudo chown -v $USER ${LFS}

    ask sudo mount -v -t ext4 ${LFS_DISK}2 ${LFS}
fi

# Download all packages
source packages.sh

# Builds stage 1
declare -a stage1_list=(binutils gcc linux glibc libstdc++)
for package in ${stage1_list[@]}; do
    if [[ -n $compileonly ]] && [[ $compileonly != $package ]]; then
        continue
    fi
    log "[Stage 1] $package..."
    source compile.sh stage1 $package
done
