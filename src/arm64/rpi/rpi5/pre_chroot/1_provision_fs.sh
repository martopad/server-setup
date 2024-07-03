#!/bin/bash
set -ex

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk --wipe-partitions always "${ARGPY_DRIVE_TARGET}"
  g # clear the in memory partition table as GPT
  n
  1

  +3G
  n
  2

  +8G
  n
  3


  t
  1
  11 # set partition 1 to Microsoft basic data
  t
  2
  19 # set partiion 2 to Linux swap
  p
  w
  q
EOF

mkfs -t vfat "${ARGPY_PART_BOOT}"
mkswap --pagesize 16384 "${ARGPY_PART_SWP}"
mkfs -t ext4 "${ARGPY_PART_ROOT}"
