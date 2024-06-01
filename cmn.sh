#!/bin/bash


CMN_SCRIPT_DIR=$(realpath "$0")
CMN_BASE_DIR=$(dirname "$SCRIPT_DIR")
CMN_DL_DIR="${BASE_DIR}/downloads"


get_eselect_number_from_list() {
    what_to_list=$1
    value_to_pick=$2
    eselect "$what_to_list" list | grep "$value_to_pick" | awk '{ print $1 }' | sed 's/[^a-zA-Z0-9]//g
}
