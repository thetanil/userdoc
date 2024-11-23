#!/bin/sh
set -e

OLDPWD=$(pwd)
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

cd $TMPDIR
# unzip /tmp/act_artifacts/1/upina_make/upina_make.zip
unzip /tmp/act_artifacts/1/upina_fbtk/upina_fbtk.zip

mkdir -pv ./input
mkdir -pv ./output
cp -rv $OLDPWD/upina/fbtk/* ./input/
# cp -v "$OLDPWD/upina/fbtk/Makefile" ./input/Makefile

    # -display virtio-vga \
    # -serial none -device isa-serial,chardev=s1 \
    # -chardev stdio,id=s1,signal=off \
    # -device bochs-display \
    # -device ati-vga \
    # -device virtio-vga \
qemu-system-x86_64 \
    -no-reboot \
    -vga qxl \
    -cpu host \
    -enable-kvm \
    -m 1g \
    -kernel bzImage \
    -serial mon:stdio \
    -append "panic=-1 notsc console=ttyS0 vga=0x34b" \
    -initrd rootfs-new.cpio \
    -nic user,model=virtio-net-pci \
    -virtfs local,path=input,mount_tag=host0,security_model=none,id=host0 \
    -virtfs local,path=output,mount_tag=host1,security_model=none,id=host1

cp -rv ./output/* $OLDPWD/output/