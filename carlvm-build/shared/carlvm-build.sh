#!/bin/sh
set -e

iso_file="chimera-linux-x86_64-LIVE-20241027-base.iso"
iso="https://repo.chimera-linux.org/live/latest/$iso_file"
disk="disk.qcow2"
size="1G"

# check if qemu is installed with command
if command -v qemu-system-x86_64 > /dev/null 2>&1; then
    echo "qemu-system-x86_64 is available"
else
    echo "qemu-system-x86_64 could not be found"
    exit 1
fi

# check if the iso exists
if [ ! -f "$iso_file" ]; then
    echo "Downloading iso"
    curl -O "$iso"
fi

# create a disk image
if [ ! -f "$disk" ]; then
    qemu-img create -f qcow2 "$disk" "$size"
fi


        # -initrd ./alpine-minirootfs-3.20.3-x86_64.cpio \
        # -kernel ../bzImage \
        # -append "notsc" \
        # -serial stdio \
        # -display none \
        # -nographic \


launch() {
    qemu-system-x86_64 \
        -m 2G    \
        -cpu host \
        -enable-kvm  \
        -drive file="$disk",media=disk,if=virtio,cache=writeback \
        -drive file="$iso_file",media=cdrom,index=0,readonly=on,if=ide \
        -virtfs local,path=../shared,mount_tag=host0,security_model=none,id=host0
}

mount_host0() {
    mkdir -p /mnt/host0 && \
    mount -t 9p -o trans=virtio host0 /mnt/host0
    # ls /mnt/bla/chimera-linux-x86_64-ROOTFS-20241027-bootstrap.tar.gz 
}

launch



