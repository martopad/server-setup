#! /usr/bin/env python3

import os
import subprocess
import sys

bdir=os.path.dirname(os.path.realpath(sys.argv[0]))

#subprocess.run(args=["env"], check=True)
#print(os.environ)

# Note that this is called by a parent subprocess.run being chroot.
# This is script is executed after being chrooted by the same parent process..
def rcmd(cmd: list[str]) -> None:
    subprocess.run(
        args=cmd,
        check=True
    )

#rcmd([f"{bdir}/1_setup_gentoo_base.sh"])
#rcmd([f"{bdir}/2_setup_kernel.sh"])
rcmd([f"{bdir}/3_configure_system.sh"])
rcmd([f"{bdir}/4_install_tools.sh"])
