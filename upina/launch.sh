#!/bin/sh
set -e

mkdir -pv ./input
mkdir -pv ./output

qemu-system-x86_64 \
    -display none \
    -no-reboot \
    -no-user-config \
    -nodefaults \
    -m 1g \
    -kernel bzImage \
    -nographic \
    -serial none -device isa-serial,chardev=s1 \
    -chardev stdio,id=s1,signal=off \
    -append "panic=-1 notsc" \
    -initrd rootfs-new.cpio \
    -nic user,model=virtio-net-pci \
    -virtfs local,path=input,mount_tag=host0,security_model=none,id=host0 \
    -virtfs local,path=output,mount_tag=host1,security_model=none,id=host1
