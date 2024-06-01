#!/bin/bash

ARG_MNT_PNT=$1
ARG_ARCH=$2
ARG_INIT_SYS=$3

# mounting has been removed from this script
# it is better to put the responsibility at the upper level.
# mount "${ARG_ROOT_PARTITION}" "${ARG_MNT_PNT}"

# Scriptified mechanism to fetch stage3 acquired from:
# https://github.com/gentoo/gentoo-docker-images/blob/master/stage3.Dockerfile
BASE_URL="https://ftp.agdsn.de/gentoo/releases/amd64/autobuilds/"
TXT_FILE="latest-stage3-${ARG_ARCH}-${ARG_INIT_SYS}.txt"
FULL_URL="${BASE_URL}/${TXT_FILE}"
wget -c -P "${ARG_MNT_PNT}" "${FULL_URL}"
STAGE3_FILE="$(sed -n '6p' "${ARG_MNT_PNT}/${TXT_FILE}" | cut -f 1 -d ' ')"
echo "Fetching Stage3: ${BASE_URL}/${STAGE3_FILE}"
wget -c -P "${ARG_MNT_PNT}" "${BASE_URL}/${STAGE3_FILE}"
tar xpf ${ARG_MNT_PNT}/stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner -C "${ARG_MNT_PNT}"
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

