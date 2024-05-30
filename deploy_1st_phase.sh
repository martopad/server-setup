#!/bin/bash

CMN_SCRIPT_DIR=$(realpath "$0")
CMN_BASE_DIR=$(dirname "$SCRIPT_DIR")
CMN_DL_DIR="${BASE_DIR}/downloads"

${CMN_BASE_DIR}/1_provision_fs.sh "/dev/nvme0n1"
${CMN_BASE_DIR}/2_create_mount_points.sh
${CMN_BASE_DIR}/3_install_system.sh "/dev/nvme0n1p3" "/mnt/gentoo/"
