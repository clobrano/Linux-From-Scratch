#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
# Install Linux API Headers

# Make sure there are no stale files embedded in the package
make mrproper

# Install the user visible kernel headers
make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include $LFS/usr
