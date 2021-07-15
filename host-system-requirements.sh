#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

set -e
if [[ $(uname -n) == "fedora" ]]; then
    sudo dnf install bash binutils bison bzip2 coreutils diffutils gawk gcc glibc grep gzip m4 make patch perl python sed tar texinfo xz yacc
fi
