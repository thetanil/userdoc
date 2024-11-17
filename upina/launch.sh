#!/bin/sh
set -e

OLDPWD=$(pwd)
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

cd $TMPDIR
unzip /tmp/act_artifacts/1/upina_make/upina_make.zip

mkdir -pv ./input
mkdir -pv ./output
cp -v "$OLDPWD/upina/make/run.sh" ./input/run.sh
cp -v "$OLDPWD/upina/make/Makefile" ./input/Makefile

qemu-system-x86_64 \
    -display none \
    -no-reboot \
    -no-user-config \
    -nodefaults \
    -cpu host \
    -enable-kvm \
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
