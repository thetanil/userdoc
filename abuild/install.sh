#!/bin/sh
set -e

# -display gtk \

qemu-system-x86_64 \
    -m 512 \
    -cpu host \
    -enable-kvm \
    -nographic \
    -nic user \
    -boot d \
    -cdrom alpine-standard-3.20.3-x86_64.iso \
    -hda alpine.qcow2
