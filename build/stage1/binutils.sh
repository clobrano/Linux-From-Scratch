#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## This script is supposed to run inside binutils source folder.

# Be sure that LFS is set
set -u

mkdir -pv build
pushd build
../configure --prefix=${LFS}/tools \
             --with-sysroot=${LFS} \
             --target=${LFS_TGT} \
             --disable-nls \
             --disable-werror
make
make install
popd
