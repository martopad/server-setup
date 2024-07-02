#!/usr/bin/env python3

import os
import subprocess
import sys
import configparser

base_dir=os.path.dirname(os.path.realpath(sys.argv[0]))
variables_to_inject = {
    "${INJECTED_BASE_DIR}": base_dir
    } 

class InterpolationWithEnvVarsAndCustomDictionary(configparser.ExtendedInterpolation):
    def before_read(self, parser, section, option, value):
        value = super().before_read(parser, section, option, value)
        env_expanded_value = os.path.expandvars(value)
        var_injected_value = env_expanded_value
        for key, value in variables_to_inject.items():
            var_injected_value = var_injected_value.replace(key, value)
        return var_injected_value

user_conf = configparser.ConfigParser(interpolation = InterpolationWithEnvVarsAndCustomDictionary())
user_conf.optionxform = str # preserve field-name cases
user_conf.read(f"{base_dir}/config.ini")

global_env = dict(os.environ) | dict(user_conf.items('ARGPY'))


def run_cmd(cmd: list[str]) -> None:
    subprocess.run(
        args = cmd,
        #env = dict(user_conf.items('ARGPY')),
        env = global_env, # I do not know why appending the os.environ makes post-chroot
                          # scripts work...
        check = True
        )

def run_bash_script_chrooted(filename: str, path_to: str) -> None:
    chrooted_dest = f"/{filename}"
    run_cmd(["cp", "-a", f"{path_to}/{filename}", f"{user_conf['ARGPY']['ARGPY_MNT_ROOT']}/{chrooted_dest}"])
    run_cmd([f"{base_dir}/exec_as_chroot.sh", chrooted_dest])
    run_cmd(["rm", "-f", f"{user_conf['ARGPY']['ARGPY_MNT_ROOT']}/{chrooted_dest}"])

#subprocess.run(args=["which", "bzip2"])
#subprocess.run(args=["which", "bzip2"], check=True, shell=True)

#print(user_conf['ARGPY']['ARGPY_DRIVE_TARGET'])
#run_cmd([f"{base_dir}/test.sh"])


if int(user_conf['CONTROL']['DO_1']):
    run_cmd([f"{base_dir}/1_provision_fs.sh"])

if int(user_conf['CONTROL']['DO_2']):
    run_cmd(["swapon", user_conf['ARGPY']['ARGPY_PART_SWP']]) #TODO: stateful action across runs
    #maybe somesort of "persistent/stateful flag" so that the script is aware with these actions
    run_cmd(["mkdir", "--parents", user_conf['ARGPY']['ARGPY_MNT_ROOT']])
    run_cmd(["mount", user_conf['ARGPY']['ARGPY_PART_ROOT'], user_conf['ARGPY']['ARGPY_MNT_ROOT']])
    run_cmd([f"{base_dir}/2_install_system.sh"])

if int(user_conf['CONTROL']['DO_3']):
    #run_cmd(["mkdir", "--parents", user_conf['ARGPY']['ARGPY_MNT_BOOT']])
    #run_cmd(["mount", user_conf['ARGPY']['ARGPY_PART_BOOT'], user_conf['ARGPY']['ARGPY_MNT_BOOT']])
    #arch-chroot behavior, wrapping it in python doesnt inherit shell env
    #run_cmd([f"{base_dir}/3_setup_system.sh"])
    run_cmd(["rsync", "-a", f"{base_dir}/root/", user_conf['ARGPY']['ARGPY_MNT_ROOT']])
    run_cmd(["chown", "-R", "root:root", user_conf['ARGPY']['ARGPY_MNT_ROOT']])
    run_bash_script_chrooted("1_setup_gentoo_base.sh", f"{base_dir}/root/after_chroot")
    run_bash_script_chrooted("2_setup_kernel.sh", f"{base_dir}/root/after_chroot")
    run_bash_script_chrooted("3_configure_system.sh", f"{base_dir}/root/after_chroot")
    run_bash_script_chrooted("4_install_tools.sh", f"{base_dir}/root/after_chroot")
    #run_bash_script_chrooted("test.sh", f"{base_dir}/root/after_chroot")
#TODO missing fstab configuration for additional storage
if int(user_conf['CONTROL']['DO_4']):
    run_cmd(["umount", "-R", user_conf['ARGPY']['ARGPY_MNT_ROOT']])


#${BASE_DIR}/1_provision_fs.sh
#swapon "${PART_SWP}"

#mkdir --parents "${MNT_ROOT}"
#mount "${PART_ROOT}" "${MNT_ROOT}"
#${BASE_DIR}/2_install_system.sh "${MNT_ROOT}" "amd64" "openrc"

#mkdir --parents "${MNT_BOOT}"
#mount "${PART_BOOT}" "${MNT_BOOT}"
#${BASE_DIR}/3_setup_system.sh "${MNT_ROOT}"

#umount -R "${MNT_ROOT}"

