#!/bin/sh

REPO_DIR=$(dirname $0)
cd ${REPO_DIR}
REPO_DIR=$(pwd)

for SUB_REPO in $(find ${REPO_DIR} -maxdepth 1 -mindepth 1 -type d); do
    if [ -f "${SUB_REPO}/PKGBUILD" ]; then
        cd ${SUB_REPO}
        echo "=> Update sums for $(basename ${SUB_REPO})"
        updpkgsums
    fi
done

