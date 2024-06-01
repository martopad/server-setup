# server-setup

Goals:
1) Automate provisioning as much as possible
2) Distcc
3) Kubernetes

Question marks/ possible additional learning points:
1) Bootable disk creation
    - dd works but it takes up the whole drive and putting it in one partition doesnt work
    - Rufus does it as I expect (1 bootable partition and the rest for data like provisioning scripts)

For configuration
setup a config.json or config.toml or config.yaml (which ever you prefer)
to configure input for the scripts. Maybe a good naming convention would be
PYCONF_*
PYCONF_TARGET_DRIVE
PYCONF_ROOT_PARTITION
It might be a big complicated for now. Park it for now. 
Many things are janky right now but we need to go green first before
refactor. 
1) Phase 1 install root
2) Phase 2 configure system chroot

Also, think about making ths whole process reproducible.
Possible routes:
1) Using a fixed stage3 and version controlled portage repo (/var/db/repos/gentoo)
2) Creating a stage 4 image (will likely need a bigger bootstrap drive)

Improvements:
1) put some mounting checks to make sure that mounting is safe


Notes:
eselect profile list | grep "default/linux/amd64/23.0 (stable)" | awk '{ print $1 }' | sed 's/[^a-zA-Z0-9]//g
ugly but try this to automate eselect calls
