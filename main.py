#!/usr/bin/env python3

import argparse
import configparser
import os
import pathlib
import subprocess
import sys

parser = argparse.ArgumentParser()
parser.add_argument(
    "--conf-file",
    action='store',
    required=True,
    type=pathlib.Path,
    help="specifies which configuration file to use"
    )
args = parser.parse_args()

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
if args.conf_file.exists():
    user_conf.read(args.conf_file)
else:
    raise RuntimeError(f"Config file passed does not exist: {args.conf_file}")

global_env = dict(os.environ) | dict(user_conf.items('ARGPY'))
def run_cmd(cmd: list[str]) -> None:
    subprocess.run(
        args = cmd,
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
def extract_number_from_file(file: pathlib.Path) -> int:
    filename: str = file.stem
    splitted = filename.split("_")
    return int(splitted[0])
 
pre_chroot_scripts = pathlib.Path(f"{user_conf['ARGPY']['ARGPY_DIRS_SCRIPTS']}/pre_chroot")
to_chroot_scripts = pathlib.Path(f"{user_conf['ARGPY']['ARGPY_DIRS_SCRIPTS']}/to_chroot")
#print(to_chroot_scripts.iterdir())


if int(user_conf['CONTROL']['DO_1']):
    run_cmd([f"{pre_chroot_scripts}/1_provision_fs.sh"])

if int(user_conf['CONTROL']['DO_2']):
    run_cmd(["swapon", user_conf['ARGPY']['ARGPY_PART_SWP']]) #TODO: stateful action across runs
    #maybe somesort of "persistent/stateful flag" so that the script is aware with these actions
    run_cmd(["mkdir", "--parents", user_conf['ARGPY']['ARGPY_MNT_ROOT']])
    run_cmd(["mount", user_conf['ARGPY']['ARGPY_PART_ROOT'], user_conf['ARGPY']['ARGPY_MNT_ROOT']])
    run_cmd([f"{pre_chroot_scripts}/2_install_system.sh"])

if int(user_conf['CONTROL']['DO_3']):
    #run_cmd(["mkdir", "--parents", user_conf['ARGPY']['ARGPY_MNT_BOOT']])
    #run_cmd(["mount", user_conf['ARGPY']['ARGPY_PART_BOOT'], user_conf['ARGPY']['ARGPY_MNT_BOOT']])
    #arch-chroot behavior, wrapping it in python doesnt inherit shell env
    #run_cmd([f"{base_dir}/3_setup_system.sh"])
    #run_cmd(["rsync", "-a", f"{user_conf['ARGPY']['CFG_DIRS_SCRIPTS']}/root/", user_conf['ARGPY']['ARGPY_MNT_ROOT']])
    #run_cmd(["chown", "-R", "root:root", user_conf['ARGPY']['ARGPY_MNT_ROOT']])
    listified = list(to_chroot_scripts.iterdir())
    listified.sort(key=extract_number_from_file)
    for script in listified:
        #run_bash_script_chrooted(script.name, script.parent)
        print(script.name)
        print(script.parent)
    #run_bash_script_chrooted("test.sh", f"{base_dir}/root/after_chroot")
#TODO missing fstab configuration for additional storage
if int(user_conf['CONTROL']['DO_4']):
    run_cmd(["swapoff", user_conf['ARGPY']['ARGPY_PART_SWP']]) #TODO: stateful action across runs
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

