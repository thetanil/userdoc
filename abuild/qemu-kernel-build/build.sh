#!/bin/bash
# apk add xz gcc flex bison make curl bash build-base linux-headers

set -e

echo "Building dumb init"
sleep 2
pushd src/dumb-init
gcc -O2 dumb-init.c -o ../../src/overlay/dumb-init
popd

echo "Downloading kernel source"
sleep 2
rm -rf linux-6.6.58
curl -O https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.6.58.tar.xz
tar xvf linux-6.6.58.tar.xz
cp src/qemu-kernel-config linux-6.6.58/.config

pushd linux-6.6.58
echo "Building kernel"
sleep 2
make -j8
cp arch/x86/boot/bzImage ../output/bzImage
popd

echo "Downloading alpine rootfs"
sleep 2
rm -rf alpine-rootfs
curl -O https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-minirootfs-3.20.3-x86_64.tar.gz
mkdir -pv alpine-rootfs
pushd alpine-rootfs
tar xvf ../alpine-minirootfs-3.20.3-x86_64.tar.gz
cp ../src/overlay/* .
chmod +x init
chmod +x dumb-init
find . | cpio -o -H newc > ../output/rootfs.cpio
popd

