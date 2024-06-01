#!/bin/bash

set ex

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")
DL_DIR="${BASE_DIR}/downloads"

DRIVE_TARGET="/dev/nvme0n1"
PART_BOOT="${DRIVE_TARGET}p1"
PART_SWP="${DRIVE_TARGET}p2"
PART_ROOT="${DRIVE_TARGET}p3"

MNT_ROOT="/mnt/gentoo"
MNT_BOOT="${MNT_ROOT}/efi"

${BASE_DIR}/1_provision_fs.sh "${DRIVE_TARGET}"
swapon "${PART_SWP}"

mkdir --parents "${MNT_ROOT}"
mount "${PART_ROOT}" "${MNT_ROOT}"
${BASE_DIR}/2_install_system.sh "${MNT_ROOT}" "amd64" "openrc"

mkdir --parents "${MNT_BOOT}"
mount "${PART_BOOT}" "${MNT_BOOT}"
${BASE_DIR}/3_setup_system.sh "${MNT_ROOT}"

umount -R "${MNT_ROOT}"
