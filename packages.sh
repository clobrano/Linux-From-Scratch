#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## Get Packages for cross-toolchain
export LFS=/mnt/lfs

mkdir -pv ${LFS}/sources
# Make sources directory writable and sticky.
# “Sticky” means that even if multiple users have write
# permission on a directory, only the owner of a file can
# delete the file within a sticky directory
sudo chmod -v a+wt ${LFS}/sources

while read line; do
    name=`echo $line | cut -d";" -f1`
    version=`echo $line | cut -d";" -f2`
    url=`echo $line | cut -d";" -f3 | sed "s/@/$version/g"`
    md5sum=`echo $line | cut -d";" -f4`
    packagename=`basename ${url}`

    if [ ! -f ${LFS}/sources/${packagename} ]; then
        pushd ${LFS}/sources
        log "Downloading ${name} v${version}"
        wget ${url}
        if ! echo "${md5sum}  ${packagename}" | md5sum --check -; then
            err "MD5sum check failed for ${name} v${version}. Removing the package"
            rm ${packagename}
            popd
            exit 1
        fi
        popd
    fi
done < packages.csv

# Some content (e.g. patches) is missing from my CSV above, use
# the LFS list to complete the download.
CWD=$(pwd)
pushd ${LFS}/sources
while read line; do
    name=$(basename ${line})
    #log "Checking ${name} (from ${line})"
    if [[ $(ls ${name} | wc -l) == "1" ]]; then
        #log "${name} already installed"
        continue
    fi
    log "Downloading ${name}"
    wget $line
done < ${CWD}/packages.all.list
popd
