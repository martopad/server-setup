# server-setup

Goals:
1) Automate provisioning as much as possible
2) Kubernetes
3) Ansible

Question marks/ possible additional learning points:
1) Bootable disk creation
    - dd works but it takes up the whole drive and putting it in one partition doesnt work
    - Rufus does it as I expect (1 bootable partition and the rest for data like provisioning scripts)
2) Manual steps when it comes to provisioning the device
    - BIOS setup (like making it boot into the USB instead of the out-of-the-box OS)
3) Required post-creation steps
    - efibootmgr clean up. What if there is already an efiboot entry for the out-of-the-box OS.

Improvements:
1) put /etc/portage as part of source control. Maybe it's own git repo?
2) For configuration
    setup a config.json or config.toml or config.yaml (which ever you prefer)
    to configure input for the scripts. Maybe a good naming convention would be
        PYCONF_*
        PYCONF_TARGET_DRIVE
        PYCONF_ROOT_PARTITION
    It might be a bit complicated for now, park it. 
        1) Phase 1 install root
        2) Phase 2 configure system chroot
3) Distcc fun. Include cross compilation. 

Also, think about making ths whole process reproducible.
Possible routes:
1) Using a fixed stage3 and version controlled portage repo (/var/db/repos/gentoo)
2) Creating a stage 4 image (will likely need a bigger bootstrap drive)



