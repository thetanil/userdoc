cloud-hypervisor \
    --kernel bzImage \
    --initramfs rootfs.cpio \
    --cmdline "console=hvc0" \
    --memory size=64M \
    --serial null \
    --console tty
