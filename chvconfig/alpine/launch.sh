#!/bin/sh
set -e

# --disk path=../../images/alpine-minirootfs-3.20.3-x86_64.qcow2 \
cloud-hypervisor \
    --kernel ./vmlinuz-virt \
	--initramfs ./initramfs-virt \
	--cmdline "console=hvc0 root=/dev/vda1 init=/bin/sh" \
	--cpus boot=4 \
	--memory size=128M