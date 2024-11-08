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
    # -drive file=mydisk.qcow2,format=qcow2 \
    # -hda mydisk.qcow2 \
    # -drive format=raw,file=myimage.img \
    # -fsdev local,security_model=passthrough,id=fsdev0,path=/tmp/share \
    # -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare

qemu-system-x86_64 \
    -kernel ./bzImage \
    -initrd ./alpine-minirootfs-3.20.3-x86_64.cpio \
    -append "notsc" \
    -m 512 \
    -cpu host \
    -no-reboot \
    -device isa-debug-exit \
    -enable-kvm  \
    -append "root=/dev/vda console=ttyS0 nogui" \
    -nographic \
    -drive file=mydisk.qcow2,media=disk,if=virtio,cache=writeback \
    -virtfs local,path=./shared,mount_tag=hostshare,security_model=passthrough,id=hostshare