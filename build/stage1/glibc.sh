#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
# The Glibc package contains the main C library.
# This library provides the basic routines for allocating memory, searching directories, opening and closing files, reading and writing files, string handling, pattern matching, arithmetic, and so on

set -eu
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

# Patch to use FHS-compliant locations
patch -Np1 -i ../glibc-2.33-fhs-1.patch

mkdir -v build
pushd build

../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=$LFS/usr/include    \
      libc_cv_slibdir=/lib
make DESTDIR=$LFS install

# sanity check
#echo 'int main(){}' > dummy.c
#$LFS_TGT-gcc dummy.c
#readelf -l a.out | grep '/ld-linux'
popd
