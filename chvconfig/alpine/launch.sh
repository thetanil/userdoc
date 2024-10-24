#!/bin/sh
set -e

# --disk path=../../images/alpine-minirootfs-3.20.3-x86_64.qcow2 \
# --initramfs ./initramfs-virt \
# cloud-hypervisor \
#     --kernel ./vmlinuz-virt \
# 	--disk path=../../images/alpine-uefi-2024-10-24.qcow2 \
# 	--cmdline "console=hvc0 root=/dev/vda1 init=/sbin/poweroff -f" \
# 	--cpus boot=4 \
# 	--memory size=1G

# sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
# sudo systemctl enable libvirtd
# sudo systemctl start libvirtd
# sudo systemctl enable --now libvirtd	


    # -drive file=../../images/alpine-uefi-2024-10-24.qcow2,if=virtio \
qemu-system-x86_64 \
    -kernel ./vmlinuz-virt \
	-initrd ./initramfs-virt \
    -append "console=ttyS0 root=/dev/vda1 init=/bin/sh" \
    -smp 4 \
    -m 1G