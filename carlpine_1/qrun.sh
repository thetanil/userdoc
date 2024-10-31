qemu-system-x86_64 -kernel bzImage \
    -initrd rootfs.cpio \
    -nodefaults \
    -serial stdio \
    -nographic \
    -enable-kvm \
    -vga none \
    -no-reboot \
    -cpu host \
    -m 64M \
    -net none

