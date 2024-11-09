#!/bin/sh

# check if qemu is installed
if ! command -v qemu-system-x86_64 &> /dev/null
then
    echo "qemu-system-x86_64 could not be found"
    exit
fi

launch() {
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
        -initrd ./alpine-minirootfs-3.20.3-x86_64.cpio \
        -drive file=mydisk.qcow2,media=disk,if=virtio,cache=writeback \
        -virtfs local,path=./shared,mount_tag=host0,security_model=none,id=host0
}


mkvda() {
    qemu-img create -f qcow2 mydisk.qcow2 1G
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
        -initrd ./alpine-minirootfs-3.20.3-x86_64.cpio \
        -drive file=mydisk.qcow2,media=disk,if=virtio,cache=writeback \
        -virtfs local,path=./shared,mount_tag=host0,security_model=none,id=host0
}
# mkdir /mnt/vda
# mkdir /mnt/vda1
# fdisk /dev/vda

# mkfs.ext2 /dev/vda1
# mount /dev/vda /mnt/vda/
# mount /dev/vda1 /mnt/vda1/