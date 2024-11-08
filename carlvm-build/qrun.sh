#!/bin/bash

# qemu-system-x86_64 \
#           -kernel ./bzImage \
#           -initrd ./alpine-minirootfs-3.20.3-x86_64.cpio \
#           -append "notsc" \
#           -m 64M \
#           -cpu host \
#           -no-reboot \
#           -device isa-debug-exit \
#           -enable-kvm  \
#           -nographic

qemu-system-x86_64 \
    -kernel ./bzImage \
    -initrd ./alpine-minirootfs-3.20.3-x86_64.cpio \
    -append "notsc" \
    -m 512 \
    -cpu host \
    -no-reboot \
    -device isa-debug-exit \
    -enable-kvm  \
    -nographic \
    -drive file=mydisk.qcow2,format=qcow2 \
    -virtfs local,path=./shared,mount_tag=hostshare,security_model=passthrough,id=hostshare
