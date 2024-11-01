#!/bin/sh
set -e

current_dir=$(pwd)

# download alpine-standard-3.20.3-x86_64.iso
# https://github.com/alpinelinux/alpine-make-vm-image
# https://wiki.alpinelinux.org/wiki/Install_Alpine_in_Qemu
# -display gtk \

qemu-system-x86_64 \
    -m 512 \
    -cpu host \
    -enable-kvm \
    -nic user \
    -hda alpine.qcow2 \
    -nographic \
    -enable-kvm \
    -fsdev local,id=fsdev0,path="$current_dir",security_model=none \
    -device virtio-9p-pci,fsdev=fsdev0,mount_tag=hostshare