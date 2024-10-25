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
    # -serial mon:stdio \
    # -d guest_errors,unimp
    # -smp 4 \
    # -device virtio-blk-pci,drive=root \
# qemu-system-x86_64 \
#     -M microvm,x-option-roms=off,isa-serial=off,rtc=off \
#     -drive id=root,file=../../images/alpine-bios-2024-10-24.qcow2,if=none,format=qcow2 \
#     -device virtio-blk-device,drive=root \
#     -m 1G \
#     -nographic \
#     -cpu host \
#     -enable-kvm \
#     -nodefaults \
#     -no-user-config \
#     -nographic \
#     -no-reboot \
#     -device virtio-serial-device \
#     -chardev stdio,id=virtiocon0 \
#     -device virtconsole,chardev=virtiocon0 \
#     -kernel ./vmlinuz-virt \
#     -initrd ./initramfs-virt \
#     -append "console=hvc0 root=/dev/vda rw reboot=t panic=-1"

# qemu-system-x86_64 -M microvm,x-option-roms=off,isa-serial=off,rtc=off -enable-kvm -cpu host \
#     -nographic -no-reboot -device virtio-serial-device -chardev stdio,id=virtiocon0 \
#     -device virtconsole,chardev=virtiocon0 -kernel ./vmlinuz-virt -append "console=hvc0 init=/bin/sh"
    # --initramfs ./initramfs-virt \

cloud-hypervisor \
    --kernel ./vmlinuz-virt \
    --disk path=../../images/alpine-bios-2024-10-24.raw \
    --cmdline "console=hvc0 root=/dev/vda0 rw" \
    --memory size=512M \
    --serial null \
    --console tty