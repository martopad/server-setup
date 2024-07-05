#!/bin/bash
set -ex

get_eselect_number_from_list() {
    what_to_list=$1
    value_to_pick=$2
    eselect "$what_to_list" list | grep "$value_to_pick" | awk '{ print $1 }' | sed 's/[^a-zA-Z0-9]//g'
}

echo "en_US ISO-8859-1" > /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

eselect locale set $(get_eselect_number_from_list "locale" "en_US.utf8")
