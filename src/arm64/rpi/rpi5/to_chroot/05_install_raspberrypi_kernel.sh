#!/bin/bash
set -ex

# Note: check "raspberrypi-kernel" configuration files in root/etc/portage directory
# As of writting, I version locked it to be, currently being tested, 6.6.31_p20240529.
# The version that matches sys-kernel/raspberrypi-image and sys-kernel/raspberrypi-sources.
# I expect after a few months this will be widely available without unmasking.

emerge --ask --verbose --getbinpkg \
	sys-kernel/raspberrypi-image \
	sys-boot/raspberrypi-firmware \
	sys-kernel/raspberrypi-sources

sed -i s/'root=.* '/"root=${ARGCHROOT_PART_ROOT} "/ /boot/cmdline.txt
