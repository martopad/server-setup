#!/bin/bash
set -ex

git -C "${ARGPY_DIRS_FILES}" submodule update --init --recursive

#wget -c -P "${BASE_DIR}/root/var/cache/distfiles/" "http://distfiles.gentoo.org/distfiles/b4/NetworkManager-1.46.0.tar.xz"
# Scriptified mechanism to fetch stage3 acquired from:
# https://github.com/gentoo/gentoo-docker-images/blob/master/stage3.Dockerfile
BASE_URL="https://ftp.agdsn.de/gentoo/releases/arm64/autobuilds/"
TXT_FILE="latest-stage3-${ARGCHROOT_ARCH}-${ARGCHROOT_INIT_SYS}.txt"
FULL_URL="${BASE_URL}/${TXT_FILE}"
wget -c -P "${ARGPY_MNT_ROOT}" "${FULL_URL}"
STAGE3_PATH="$(sed -n '6p' "${TXT_FILE}" | cut -f 1 -d ' ')"
wget -c -P "${ARGPY_MNT_ROOT}" "${BASE_URL}/${STAGE3_PATH}"

#mount "${ARGPY_PART_ROOT}" "${ARGPY_MNT_ROOT}"
pushd "${ARGPY_MNT_ROOT}"
tar xpf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner -C ${ARGPY_MNT_ROOT}

#mount "${ARGPY_PART_BOOT}" "${ARGPY_MNT_BOOT}"
rsync -r "${ARGPY_DIRS_FILES}/firmware/boot/" "${ARGPY_MNT_BOOT}/"
rsync -r "${ARGPY_DIRS_FILES}/firmware/modules" "${ARGPY_MNT_ROOT}/lib/"

rsync -r "${ARGPY_DIRS_FILES}/root/" "${ARGPY_MNT_ROOT}/"
sed -ie 's/f0:12345/#0f:12345/' "${ARGPY_MNT_ROOT}/etc/inittab"

#Wifi
#wget -P "${ARGPY_MNT_ROOT}/lib/firmware/brcm" \
#	https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt 
#wget -P "${ARGPY_MNT_ROOT}/lib/firmware/brcm" \
#	https://github.com/armbian/firmware/raw/master/brcm/brcmfmac43430-sdio.bin
rsync -a "${ARGPY_DIRS_FILES}/firmware-nonfree/debian/config/brcm80211/brcm" "${ARGPY_MNT_ROOT}/lib/firmware/"
rsync -a "${ARGPY_DIRS_FILES}/firmware-nonfree/debian/config/brcm80211/cypress" "${ARGPY_MNT_ROOT}/lib/firmware/"

#Bluetooth
#wget -P "${ARGPY_MNT_ROOT}/lib/firmware/brcm" https://raw.githubusercontent.com/RPi-Distro/bluez-firmware/master/broadcom/BCM43430A1.hcd
#wget -P "${ARGPY_MNT_ROOT}/lib/firmware/brcm" https://raw.githubusercontent.com/RPi-Distro/bluez-firmware/master/broadcom/BCM4345C0.hcd

#Bootstrap Network manager for Wifi internet puposes.
# Maybe its better to do this via wired connection in the future.
#wget -P "${ARGPY_MNT_ROOT}/var/cache/distfiles/" "http://distfiles.gentoo.org/distfiles/b4/NetworkManager-1.46.0.tar.xz"


echo "Done, congratulations! Syncing first"
sync -a
#echo "Syncing and unmounting: ${ARGPY_MNT_BOOT}"
#umount "${ARGPY_MNT_BOOT}"
#echo "Done"
#echo "Synching and unmounting: ${ARGPY_MNT_ROOT}"
#umount "${ARGPY_MNT_ROOT}"
#echo "Done"
