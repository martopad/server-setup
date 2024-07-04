#!/bin/bash
set -ex

sed -ie 's/f0:12345/#0f:12345/' "${ARGPY_MNT_ROOT}/etc/inittab"

echo "${ARGCHROOT_HOSTNAME}" > "${ARGPY_MNT_ROOT}/etc/hostname"

envsubst < "${ARGPY_MNT_ROOT}/etc/fstab_template" > "${ARGPY_MNT_ROOT}/etc/fstab"
rm "${ARGPY_MNT_ROOT}/etc/fstab_template"

cp --dereference /etc/resolv.conf "${ARGPY_MNT_ROOT}/etc/"

