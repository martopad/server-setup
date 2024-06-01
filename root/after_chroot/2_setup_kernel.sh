#!/bin/bash

ARG_BOOT_DEV="/dev/nvme0n1"
ARG_BOOT_PART="1"
ARG_ROOT_PART="/dev/nvme0n1p3"

ESP="/efi"
EFI="EFI/Gentoo"

mkdir -p /efi/EFI/Gentoo

emerge --getbinpkg \
    sys-kernel/gentoo-kernel-bin \
    sys-kernel/installkernel \
    sys-kernel/gentoo-sources \
    sys-boot/efibootmgr

ARG_KERNEL_VER=$(ls -l /usr/src/linux | awk '{ printf $11 }' | sed 's/linux-//')
cp "/boot/System.map-${ARG_KERNEL_VER}" "${ESP}/${EFI}"
cp "/boot/config-${ARG_KERNEL_VER}" "${ESP}/${EFI}"
cp "/boot/initramfs-${ARG_KERNEL_VER}.img" "${ESP}/${EFI}"
cp "/boot/vmlinuz-${ARG_KERNEL_VER}" "${ESP}/${EFI}/vmlinuz-${ARG_KERNEL_VER}.efi"

efibootmgr -B -b 0050 || echo "Boot0050 does not exist. It's okay"

efibootmgr --create \
    --bootnum "0050" \
    --disk "${ARG_BOOT_DEV}" --part ${ARG_BOOT_PART} \
    --label "Gentoo" \
    --loader "\EFI\Gentoo\vmlinuz-${ARG_KERNEL_VER}.efi" \
    --unicode "root=${ARG_ROOT_PART} dokeymap looptype=squashfs loop=/image.squashfs cdroot initrd=\EFI\Gentoo\initramfs-${ARG_KERNEL_VER}.img"
