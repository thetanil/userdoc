qemu-system-x86_64 -kernel output/bzImage \
    -initrd output/rootfs.cpio \
    -nographic \
    -enable-kvm \
    -vga none \
    -no-reboot \
    -cpu host \
    -m 64m 
    #-netdev user,id=eth0,net=192.168.76.0/24,dhcpstart=192.168.76.9
#    -net none

