#!/bin/bash
set -ex

# mounting has been removed from this script
# it is better to put the responsibility at the upper level.
# mount "${ARG_ROOT_PARTITION}" "${ARGPY_MNT_ROOT}"

# Scriptified mechanism to fetch stage3 acquired from:
# https://github.com/gentoo/gentoo-docker-images/blob/master/stage3.Dockerfile
#BASE_URL="https://ftp.agdsn.de/gentoo/releases/amd64/autobuilds"
BASE_URL="http://ftp.vectranet.pl/gentoo/releases/amd64/autobuilds"
TXT_FILE="latest-stage3-${ARGCHROOT_ARCH}-${ARGCHROOT_INIT_SYS}.txt"
FULL_URL="${BASE_URL}/${TXT_FILE}"
wget -c -P "${ARGPY_MNT_ROOT}" "${FULL_URL}"
STAGE3_FILE="$(sed -n '6p' "${ARGPY_MNT_ROOT}/${TXT_FILE}" | cut -f 1 -d ' ')"
echo "Fetching Stage3: ${BASE_URL}/${STAGE3_FILE}"
wget -c -P "${ARGPY_MNT_ROOT}" "${BASE_URL}/${STAGE3_FILE}"
tar xpf ${ARGPY_MNT_ROOT}/stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner -C "${ARGPY_MNT_ROOT}"
rsync -a "${ARGPY_DIRS_FILES}/root/" "${ARGPY_MNT_ROOT}"
chown -R root:root "${ARGPY_MNT_ROOT}"
cp --dereference /etc/resolv.conf "${ARGPY_MNT_ROOT}/etc/"

