#!/bin/bash
set -ex

rsync -a "${ARGPY_BASE_DIR}/root/"  "${ARGPY_MNT_ROOT}/"

# Maybe create this as a module. Wherein main.py just throws
# scripts/strings to execute inside chroot.
arch-chroot "${ARGPY_MNT_ROOT}" << EOF
/after_chroot/setup_all.py
EOF

chown -R root:root "${ARGPY_MNT_ROOT}"
