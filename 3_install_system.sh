#!/bin/bash

ARG_ROOT_PARTITION=$1
ARG_MNT_PNT=$2
ARG_ARCH="aarch64" # $1 aarch64
ARG_INIT_SYS="openrc" # $2 openrc

if [[ -z "${ARG_ROOT_PARTITION}" ]]; then
    echo "Please pass root partition!"
    exit 1
fi

if [[ -z "${ARG_MNT_PNT}" ]]; then
    echo "Please pass mount point for root!"
    exit 1
fi

mount "${ARG_ROOT_PARTITION}" "${ARG_MNT_PNT}"
# extract stage3 here

# Scriptified mechanism to fetch stage3 acquired from:
# https://github.com/gentoo/gentoo-docker-images/blob/master/stage3.Dockerfile
BASE_URL="https://ftp.agdsn.de/gentoo/releases/arm64/autobuilds/"
TXT_FILE="latest-stage3-${ARG_ARCH}_be-${ARG_INIT_SYS}.txt"
FULL_URL="${BASE_URL}/${TXT_FILE}"
wget -c -P "${ARG_MNT_PNT}" "${FULL_URL}"
STAGE3_FILE="$(sed -n '6p' "${ARG_MNT_PNT}/${TXT_FILE}" | cut -f 1 -d ' ')"
echo "Fetching Stage3: $STAGE3_PATH"
wget -c -P "${ARG_MNT_PNT}" "${BASE_URL}/${STAGE3_FILE}"
tar xpvf ${ARG_MNT_PNT}/stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner -C "${ARG_MNT_PNT}"
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/


#chroot /mnt /bin/bash
#arch-chroot "${ARG_MNT_PNT} <<END
#echo hello world
#END
