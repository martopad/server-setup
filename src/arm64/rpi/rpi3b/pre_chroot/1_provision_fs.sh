#!/bin/bash
set -ex

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk --wipe-partitions always "${ARGPY_DRIVE_TARGET}"
  o # clear the in memory partition table
  n
  p
  1

  +128M
  n
  p
  2

  +2G
  n
  p
  3


  t
  1
  c
  t
  2
  82
  p
  w
  q
EOF

mkfs -t vfat -F 32 "${ARGPY_PART_BOOT}"
mkswap "${ARGPY_PART_SWP}"
mkfs -i 8192 -t ext4 "${ARGPY_PART_ROOT}"
