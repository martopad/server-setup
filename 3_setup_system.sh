#!/bin/bash

SCRIPT_DIR=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_DIR")

ARG_MNT_ROOT=$1

rsync -a "${BASE_DIR}/root/"  "${ARG_MNT_ROOT}/"

arch-chroot "${ARG_MNT_ROOT}" << EOF
/after_chroot/setup_all.sh
EOF

chown -R root:root "${ARG_MNT_ROOT}"
