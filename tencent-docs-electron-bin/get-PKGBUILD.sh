#!/bin/bash

wget 'https://gitlab.archlinux.org/archlinux/packaging/packages/mpv/-/raw/main/PKGBUILD' -O PKGBUILD-mpv

MAKE_DIR=$(dirname $0)
cd ${MAKE_DIR}
AUR_PKGNAME=$(basename $(pwd))

AUR_FILELIST=(
    PKGBUILD
    tencent-docs-electron.sh
)

wget "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=${AUR_PKGNAME}" -O aur.PKGBUILD
wget "https://aur.archlinux.org/cgit/aur.git/plain/tencent-docs-electron.sh?h=${AUR_PKGNAME}" -O aur.tencent-docs-electron.sh

