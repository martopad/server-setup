#!/bin/bash
set -ex
#TODO: make this configurable like some ini/yaml/toml file.
#ISSUE: using this method, setting uuid does not work
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk --wipe-partitions always "${ARGPY_DRIVE_TARGET}"
  g # wipe and start with gpt partition table
  n
  1 # /efi 
    # default start
  +5G
  t # marking partition
  1 # mark as efi, partition 1 automatically selected
  n
  2 # /swap
    # default start
  +8G # /swap
  t
  2
  19 # mark as swap partition
  n
  3 # /root
    # default start
    # up to the end
  p
  w
  q
EOF

#tune2fs /dev/nvme0n1p1 -U "1edc171a-afb2-4f36-be1c-d4d1c98661e4"
#tune2fs /dev/nvme0n1p2 -U "149eaf76-8b7f-4365-b823-e59368c09a89"
#tune2fs /dev/nvme0n1p3 -U "e4c80995-4027-4c3a-8ddb-49a14f220f20"

mkfs.vfat -F 32 "${ARGPY_PART_BOOT}"
mkfs.ext4 "${ARGPY_PART_ROOT}"
mkswap "${ARGPY_PART_SWP}"

