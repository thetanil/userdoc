#!/bin/sh

if [ -c /dev/fb0 ]; then
    export DISPLAY=:0
    ifconfig eth0 up
    sdhcp

    apk update
    rc-status
    apk add alpine-conf dbus-x11 vim xeyes xterm dbus qemu-hw-display-virtio-gpu-gl qemu-hw-display-virtio-vga qemu-hw-display-virtio-gpu mesa-vulkan-swrast mesa-dri-gallium qemu-system-x86_64 qemu-modules libvirt libvirt-qemu
    /bin/sh
    rc-status
    touch /run/openrc/softlevel
    setup-devd udev -C
    rc-service udev start
    rc-update add dbus
    rc-service dbus start
    rc-status

    setup-xorg-base
    # setup-desktop

    echo "allowed_users=anybody" > /etc/X11/Xwrapper.config
    echo "needs_root_rights=yes" >> /etc/X11/Xwrapper.config
    touch ~/.Xauthority

    # X -configure
    # cp /root/xorg.conf.new /mnt/output/xorg.conf
    cp /mnt/input/xorg.conf /etc/X11/xorg.conf
    # cp /mnt/input/xinitrc /root/.xinitrc
    startx &
    /bin/sh
    # sleep 2
    # tclsh /mnt/input/hello.tcl
    
fi