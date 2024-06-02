#!/bin/bash

ARG_BOOT_DEV="/dev/nvme0n1"
ARG_BOOT_PART="1"
ARG_ROOT_PART="/dev/nvme0n1p3"

ESP="/efi"
EFI="EFI/Gentoo"

mkdir -p /efi/EFI/Gentoo
mkdir -p /etc/dracut.conf.d

cat <<EOT > /etc/dracut.conf.d/conf.conf
uefi="yes"
kernel_cmdline="root=${ARG_ROOT_PART}"
EOT

emerge --getbinpkg \
    sys-kernel/linux-firmware \
    sys-kernel/gentoo-kernel-bin \
    sys-kernel/installkernel \
    sys-kernel/gentoo-sources \
    sys-boot/efibootmgr

# UEFI COMPLIANT SYSTEMS ==============
ARG_KERNEL_VER=$(ls -l /usr/src/linux | awk '{ printf $11 }' | sed 's/linux-//')
cp "/usr/src/linux-${ARG_KERNEL_VER}/arch/x86/boot/uki.efi" "${ESP}/${EFI}/${ARG_KERNEL_VER}-uki.efi"

# When code was not using UKI
#cp "/boot/System.map-${ARG_KERNEL_VER}" "${ESP}/${EFI}"
#cp "/boot/config-${ARG_KERNEL_VER}" "${ESP}/${EFI}"
#cp "/boot/initramfs-${ARG_KERNEL_VER}.img" "${ESP}/${EFI}"
#cp "/boot/vmlinuz-${ARG_KERNEL_VER}" "${ESP}/${EFI}/vmlinuz-${ARG_KERNEL_VER}.efi"

efibootmgr -B -b 0050 || echo "Boot0050 does not exist. It's okay"

efibootmgr --create \
    --bootnum "0050" \
    --disk "${ARG_BOOT_DEV}" --part ${ARG_BOOT_PART} \
    --label "Gentoo" \
    --loader "${EFI}/${ARG_KERNEL_VER}-uki.efi"



# NON_UEFI COMPLIANT SYSTEMS ============

# Hack for now due to minisforum not conforming with how UEFI behaves
# Minisforum hardcodes checking "\EFI\Boot\bootx64.efi" only. This can be used to
# load a secondary bootloader like grub. Manually writing boot entries using efibootmgr
# doesnt work also it just gets deleted.

EFI_MINISFORUM="EFI/Boot"
mkdir -p "${ESP}/${EFI_MINISFORUM}"
cp "/usr/src/linux-${ARG_KERNEL_VER}/arch/x86/boot/uki.efi" "${ESP}/${EFI_MINISFORUM}/bootx64.efi"


