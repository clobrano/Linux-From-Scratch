#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

set -e
has_dnf=$(which dnf | wc -l)
if [[ $has_dnf == "1" ]]; then
    sudo dnf install bash binutils bison bzip2 coreutils diffutils gawk gcc glibc grep gzip m4 make patch perl python sed tar texinfo xz yacc
fi

has_apt=$(which apt | wc -l)
if [[ $has_apt == "1" ]]; then
    sudo apt install -y binutils bison bzip2 coreutils diffutils gawk gcc libc6 grep gzip m4 make patch perl python sed tar texinfo xz-utils nyacc
fi

if [[ $has_apt == "0" ]] && [[ $has_dnf == "0" ]]; then
    echo [!] this script supports only dnf or apt
    exit 1
fi
