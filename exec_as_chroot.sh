#!/bin/bash
set -ex

arch-chroot "${ARGPY_MNT_ROOT}" << EOF
$@
EOF

