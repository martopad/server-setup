#!/bin/bash


echo tux > /etc/hostname

emerge --verbose --getbinpkg net-misc/dhcpcd
rc-update add dhcpcd default 
rc-service dhcpcd start 
# Maybe set this up with static IP, like via netifrc?? Dont know yet.

