#!/bin/bash
set -e

rsync -a "${ARGPY_BASE_DIR}/root/"  "${ARGPY_MNT_ROOT}/"

arch-chroot "${ARGPY_MNT_ROOT}" << EOF
/after_chroot/setup_all.sh
EOF

chown -R root:root "${ARGPY_MNT_ROOT}"
