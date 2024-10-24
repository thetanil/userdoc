#!/bin/sh
set -e

# --disk path=../../images/alpine-minirootfs-3.20.3-x86_64.qcow2 \
# --initramfs ./initramfs-virt \
# cloud-hypervisor \
#     --kernel ./vmlinuz-virt \
#     --initramfs ./initramfs-virt \
#     --disk path=../../images/alpine-bios-2024-10-24.qcow2 \
#     --cmdline "console=hvc0 root=/dev/vda1 init=/bin/sh" \
#     --cpus boot=4 \
#     --memory size=1G

# sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
# sudo systemctl enable libvirtd
# sudo systemctl start libvirtd
# sudo systemctl enable --now libvirtd	

    # -drive file=../../images/alpine-uefi-2024-10-24.qcow2,if=virtio \
    # -initrd ./initramfs-virt \
    # -device virtio-net,netdev=net0 \
    # -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    # -device virtio-blk-pci,drive=vd0 \
    # -kernel ./vmlinuz-virt \
    # -initrd ./initramfs-virt \
    # -append "console=ttyS0 root=/dev/vda init=/bin/sh" \
    # -serial mon:stdio \
    # -d guest_errors,unimp
    # -smp 4 \
qemu-system-x86_64 \
    -drive file=../../images/alpine-bios-2024-10-24.qcow2,if=virtio \
    -m 1G \
    -nographic \
    -cpu host \
    -serial mon:stdio \
    -enable-kvm 
