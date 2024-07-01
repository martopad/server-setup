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

def run_cmd(cmd: list["str"]) -> None:
    subprocess.run(
        args = cmd,
        env = dict(user_conf.items('ARGPY')),
        check = True
        )

#print(user_conf['ARGPY']['ARGPY_PART_SWP'])
#run_cmd([f"{base_dir}/test.sh"])

if int(user_conf['CONTROL']['DO_1']):
    run_cmd([f"{base_dir}/1_provision_fs.sh"])

if int(user_conf['CONTROL']['DO_2']):
    run_cmd(["swapon", user_conf['ARGPY']['ARGPY_PART_SWP'])
    run_cmd(["mkdir", "--parents", user_conf['ARGPY']['ARGPY_MNT_ROOT'])
    run_cmd(["mount", user_conf['ARGPY']['ARGPY_PART_ROOT'], user_conf['ARGPY']['ARGPY_MNT_ROOT'])
    run_cmd([f"{base_dir}/2_install_system.sh"])

if int(user_conf['CONTROL']['DO_3']):
    run_cmd(["mkdir", "--parents", user_conf['ARGPY']['ARGPY_MNT_BOOT'])
    run_cmd(["mount", user_conf['ARGPY']['ARGPY_PART_BOOT'], user_conf['ARGPY']['ARGPY_MNT_BOOT'])
    run_cmd([f"{base_dir}/3_setup_system.sh"])

if int(user_conf['CONTROL']['DO_4']):
    run_cmd(["umount", "-R", user_conf['ARGPY']['ARGPY_MNT_ROOT'])

#${BASE_DIR}/1_provision_fs.sh
#swapon "${PART_SWP}"

#mkdir --parents "${MNT_ROOT}"
#mount "${PART_ROOT}" "${MNT_ROOT}"
#${BASE_DIR}/2_install_system.sh "${MNT_ROOT}" "amd64" "openrc"

#mkdir --parents "${MNT_BOOT}"
#mount "${PART_BOOT}" "${MNT_BOOT}"
#${BASE_DIR}/3_setup_system.sh "${MNT_ROOT}"

#umount -R "${MNT_ROOT}"

