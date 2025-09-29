#!/bin/bash

MAKE_DIR=$(dirname $0)
cd ${MAKE_DIR}
AUR_PKGNAME=$(basename $(pwd))

AUR_FILELIST=(
    PKGBUILD
    tencent-docs-electron.sh
)

for F in ${AUR_FILELIST[@]}; do
    wget "https://aur.archlinux.org/cgit/aur.git/plain/${F}?h=${AUR_PKGNAME}" -O aur.${F}
done
