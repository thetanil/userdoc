# qemu-img create -f qcow2 base-image.qcow2 10G
# sudo modprobe nbd
# sudo qemu-nbd -c /dev/nbd0 chimera_rootfs.qcow2
# echo ',,83' | sudo sfdisk /dev/nbd0
# sudo mkfs.ext2 /dev/nbd0p1
# sudo mkdir -p /mnt/nbd0p1
# sudo mount /dev/nbd0p1 /mnt/nbd0p1
# df -h | grep /mnt/nbd0p1
# sudo umount /mnt/nbd0p1

qemu-system-x86_64 \
          -kernel ./bzImage \
          -initrd ./alpine-rootfs.cpio \
          -m 64M \
          -cpu host \
          -no-reboot \
          -device isa-debug-exit \
          -drive file=chimera_rootfs.qcow2,media=disk,if=virtio \
          -enable-kvm  \
          -nographic

# qemu-img create -f qcow2 base-image.qcow2 1G
# sudo modprobe nbd
# sudo qemu-nbd -c /dev/nbd0 base-image.qcow2
# echo ',,83' | sudo sfdisk /dev/nbd0
# sudo mkfs.ext2 /dev/nbd0p1
# sudo mkdir -p /mnt/nbd0p1
# sudo mount /dev/nbd0p1 /mnt/nbd0p1
# df -h | grep /mnt/nbd0p1
# # sudo umount /mnt/nbd0p1
# # download chimera tarball
# curl -L -o chimera.tar.gz https://repo.chimera-linux.org/live/20241027/chimera-linux-x86_64-ROOTFS-20241027-bootstrap.tar.gz
# sudo tar -xvf chimera.tar.gz -C /mnt/nbd0p1
# sudo umount /mnt/nbd0p1

qemu-system-x86_64 \
          -kernel ./bzImage \
          -initrd ./alpine-rootfs.cpio \
          -m 64M \
          -cpu host \
          -no-reboot \
          -device isa-debug-exit \
          -drive file=base-image.qcow2,media=disk,if=virtio \
          -enable-kvm  \
          -nographic

qemu-img create -f qcow2 chimera_root.qcow2 10G
sudo modprobe nbd max_part=8
sudo qemu-nbd --connect=/dev/nbd0 chimera_root.qcow2
sudo mkfs.ext4 /dev/nbd0
sudo mount /dev/nbd0 /mnt
sudo tar -xzf chimera.tar.gz -C /mnt
sudo umount /mnt
sudo qemu-nbd --disconnect /dev/nbd0


qemu-system-x86_64 \
          -kernel ./bzImage \
          -initrd ./alpine-rootfs.cpio \
          -m 2048 \
          -cpu host \
          -no-reboot \
          -device isa-debug-exit \
          -drive file=/home/user/Downloads/Arch-Linux-x86_64-basic.qcow2,format=qcow2,if=virtio \
          -boot d \
          -enable-kvm  \
          -nographic