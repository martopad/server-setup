#!/bin/bash

set ex

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")

ARG_ARCH="amd64"
ARG_ARCH_POSTFIX="x86-64"
ARG_PROFILE_NUM="23.0"
ARG_BINHOST_MIRROR="mirror.netcologne.de/gentoo"

${BASE_DIR}/1_setup_gentoo_base.sh "${ARG_ARCH}" "${ARG_ARCH_POSTFIX}" "${ARG_PROFILE_NUM}" "${ARG_BINHOST_MIRROR}"
${BASE_DIR}/2_setup_kernel.sh
${BASE_DIR}/3_configure_system.sh
${BASE_DIR}/4_install_tools.sh

