# server-setup

Design/Interface:
The provisioning process is divided into three phases:
    1) pre-chroot (2 hardcoded scripts that is executed in order)
        - disk and filsystem preparation
        - installation of base system (unzipping stage3)
    2) during chroot (executes an arbitraty amount of scripts arranged by the number indicated in filename)
        -  Running all of Gentoo-specific things (portage prep, timezone, profile setting)

Assumptions:
1) The provisioning process assumes that you can chroot into the device. This simplifies the design for my peanut brain.

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

TODO:
1) hardcorded shits (/etc/fstab, mount points /dev/nvme vs /dev/sda)
2) Hard coded to have 3 partitions for /efi, root, and swap.
3) Kernel version is automatically selected. Maybe improve this when we decide root build kernel from source.
4) Create a profiles flag so different profiles can be documented
5) Support possible profile scripts so that different types of devices can be automatically provisioned
   - Types of machines so far: personal, rpi3b+, rpi5, un100d, another personal machine.
   - Support for possible chrooting on another machine so provisioning is easier
      - this will mean creating a post-provisioning script that will be run on first startup.
6) cleanup is missing.



