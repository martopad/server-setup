#!/bin/bash
set -ex

emerge --verbose --getbinpkg \
    sys-block/io-scheduler-udev-rules

