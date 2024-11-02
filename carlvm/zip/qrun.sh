#!/bin/bash
set -e

qemu-system-x86_64 \
          -kernel ./bzImage \
          -initrd ./alpine-minirootfs-3.20.3-x86_64.cpio \
          -m 64M \
          -cpu host \
          -no-reboot \
          -device isa-debug-exit \
          -enable-kvm  \
          -nographic
