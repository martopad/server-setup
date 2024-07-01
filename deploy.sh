#!/usr/bin/env bash

set -e

#${ARGPY_BASE_DIR}/1_provision_fs.sh
#swapon "${ARGPY_PART_SWP}"
#
#mkdir --parents "${ARGPY_MNT_ROOT}"
#mount "${ARGPY_PART_ROOT}" "${ARGPY_MNT_ROOT}"
#${ARGPY_BASE_DIR}/2_install_system.sh "${ARGPY_MNT_ROOT}" "amd64" "openrc"
#
#mkdir --parents "${ARGPY_MNT_BOOT}"
#mount "${ARGPY_PART_BOOT}" "${ARGPY_MNT_BOOT}"
#${ARGPY_BASE_DIR}/3_setup_system.sh "${ARGPY_MNT_ROOT}"
#
#umount -R "${ARGPY_MNT_ROOT}"
env
${ARGPY_BASE_DIR}/test.sh
