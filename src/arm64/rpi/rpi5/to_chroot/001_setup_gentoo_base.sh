#!/bin/bash
set -ex

get_eselect_number_from_list() {
    what_to_list=$1
    value_to_pick=$2
    eselect "$what_to_list" list | grep "$value_to_pick" | awk '{ print $1 }' | sed 's/[^a-zA-Z0-9]//g'
}

# Commented for documentation. It is better to handle mounting to parent call
# mkdir /efi
# mount "${ARGCHROOT_PART_EFI}" /efi

emerge-webrsync
emerge --sync --quiet

profile_name="default/linux/${ARGCHROOT_ARCH}/${ARGCHROOT_PROFILE_NUM} (stable)"
echo "Getting profile number for: ${profile_name}"
eselect_num=$(get_eselect_number_from_list "profile" "${profile_name}")
echo "Setting profile number to: ${eselect_num}"
eselect profile set "${eselect_num}"

# Commented for documentation. Bin repo is already there
# Heavy heart but binhost is the way to go for now to quicken the provisioning
#mkdir -p /etc/portage/binrepos.conf
cat <<EOT > /etc/portage/binrepos.conf/gentoobinhost.conf 
[binhost]
priority = 9999
sync-uri = ${ARGCHROOT_BINHOST_MIRROR}/releases/${ARGCHROOT_ARCH}/binpackages/${ARGCHROOT_PROFILE_NUM}/${ARGCHROOT_ARCH_POSTFIX}/
EOT
#sed "s|distfiles.gentoo.org|${ARGCHROOT_BINHOST_MIRROR}|g" /etc/portage/binrepos.conf/gentoobinhost.conf
getuto

# This should be moved to a "when actual machine boots up"
# This cant be executed when chrooted because there is a chance that a different machine
# with different CPU can setup this storage device.
emerge --oneshot --getbinpkg app-portage/cpuid2cpuflags
echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags

emerge --verbose --getbinpkg dev-vcs/git app-eselect/eselect-repository
eselect repository disable gentoo
eselect repository enable gentoo
rm -r /var/db/repos/gentoo
emerge --sync --quiet

emerge --update --deep --newuse --getbinpkg @world
emerge --depclean

echo "Europe/Warsaw" > /etc/timezone
emerge --config sys-libs/timezone-data

echo "en_US ISO-8859-1" > /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

eselect locale set $(get_eselect_number_from_list "locale" "en_US.utf8")

