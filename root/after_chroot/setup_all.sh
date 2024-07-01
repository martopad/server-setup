#!/bin/bash

set -e

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")

${BASE_DIR}/1_setup_gentoo_base.sh
${BASE_DIR}/2_setup_kernel.sh
${BASE_DIR}/3_configure_system.sh
${BASE_DIR}/4_install_tools.sh

