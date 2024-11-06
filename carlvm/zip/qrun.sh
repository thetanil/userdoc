#!/bin/bash

qemu-system-x86_64 \
    -display none \
    -no-user-config \
    -nodefaults \
    -m 64M \
    -serial stdio \
    -cpu host \
    -enable-kvm  \
    -kernel ./bzImage \
    -append "notsc" \
    -initrd ./alpine-minirootfs-3.20.3-x86_64.cpio
