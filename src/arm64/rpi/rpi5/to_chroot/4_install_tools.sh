#!/bin/bash
set -e

emerge --verbose --getbinpkg \
    app-admin/sysklogd \
    sys-process/cronie \
    app-shells/bash-completion \
    net-misc/chrony \
    sys-fs/xfsprogs \
    sys-fs/dosfstools \
    app-editors/neovim

sed -i 's|#s0:12345:|s0:12345:|g' /etc/inittab
sed -i 's|#s1:12345:|s1:12345:|g' /etc/inittab

rc-update add sysklogd default
rc-update add cronie default
rc-update add sshd default
rc-update add chronyd default
