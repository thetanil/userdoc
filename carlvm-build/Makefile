.SILENT:
PWD != pwd
BUILD_DIR := $(PWD)/build
CACHE_DIR := $(PWD)/cache
KERNELVER := "6.6.58"
# "6.11.7"
KERNEL_SRC := $(CACHE_DIR)/linux-$(KERNELVER).tar.xz
KERNEL_SRC_PATH := $(BUILD_DIR)/linux-$(KERNELVER)
SRCPATH != realpath ../carlvm/src
IMAGE_FILE := $(BUILD_DIR)/disk.qcow2
IMAGE_SIZE := "1G"
ROOTFS_PATH := $(BUILD_DIR)/rootfs
ROOTFS_FILE := $(CACHE_DIR)/rootfs.tar.gz
ROOTFS_URL := "https://repo.chimera-linux.org/live/latest/chimera-linux-x86_64-ROOTFS-20241027-bootstrap.tar.gz"
# ROOTFS_URL := "https://repo.chimera-linux.org/live/latest/chimera-linux-x86_64-ROOTFS-20241027-full.tar.gz"
ROOTFS_IMG := $(BUILD_DIR)/rootfs.qcow2
DUMB_INIT_SRC := $(SRCPATH)/dumb-init
DUMB_INIT_BIN := $(BUILD_DIR)/dumb-init
CARL_EXIT_SRC := $(SRCPATH)/carl-exit
CARL_EXIT_BIN := $(BUILD_DIR)/carl-exit
INIT_SH := ./init
SBIN_INIT := $(ROOTFS_PATH)/sbin/init
# CARLVM_DIR := $(BUILD_DIR)/carlvm
# CARLVM_FILE := $(BUILD_DIR)/carlvm.zip
# CARLVM_URL := "https://github.com/thetanil/userdoc/releases/latest/download/carl.vm"
KERNEL_CONFIG := $(KERNEL_SRC_PATH)/.config
KERNEL_CONFIG_SRC := $(SRCPATH)/qemu-kernel-config
KERNEL_BZIMAGE := $(KERNEL_SRC_PATH)/arch/x86/boot/bzImage
MAKEJOBS != nproc
BASEISO_FILE := $(CACHE_DIR)/chimera-base.iso
BASEISO_URL := "https://repo.chimera-linux.org/live/latest/chimera-linux-x86_64-LIVE-20241027-base.iso"
BASEFULL_IMAGE := $(BUILD_DIR)/chimera-full.qcow2
BASETINY_IMAGE := $(BUILD_DIR)/carl-tiny.qcow2


all: $(IMAGE_FILE) $(ROOTFS_PATH) $(BUILD_DIR) $(CARLVM_DIR) carlvm

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(CACHE_DIR):
	mkdir -p $(CACHE_DIR)

$(KERNEL_SRC): $(CACHE_DIR)
	if [ ! -f $(CACHE_DIR)/linux-$(KERNELVER).tar.xz ]; then \
		echo "Downloading kernel source..."; \
		set -e; curl -o $(CACHE_DIR)/linux-$(KERNELVER).tar.xz https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-$(KERNELVER).tar.xz; \
	else \
		echo "Kernel source already exists"; \
	fi

$(KERNEL_SRC_PATH): $(KERNEL_SRC)
	if [ ! -d $(KERNEL_SRC_PATH) ]; then \
		echo "Extracting kernel source..."; \
		mkdir -p $(KERNEL_SRC_PATH); \
		tar -xf $(KERNEL_SRC) -C $(KERNEL_SRC_PATH) --strip-components=1; \
	else \
		echo "Kernel source already extracted"; \
	fi

$(KERNEL_CONFIG): $(KERNEL_SRC_PATH) $(KERNEL_CONFIG_SRC)
	cp $(KERNEL_CONFIG_SRC) $(KERNEL_CONFIG)

kernel: $(KERNEL_BZIMAGE)

$(KERNEL_BZIMAGE): $(KERNEL_SRC_PATH) $(KERNEL_CONFIG)
	if [ ! -f $(KERNEL_BZIMAGE) ]; then \
		echo "Building kernel..."; \
		set -e; cd $(KERNEL_SRC_PATH) && make -j$(MAKEJOBS); \
	else \
		echo "Kernel already built"; \
	fi

$(IMAGE_FILE): $(BUILD_DIR)
	if [ ! -f $(IMAGE_FILE) ]; then \
		echo "Creating image file..."; \
		set -e;	qemu-img create -f qcow2 $(IMAGE_FILE) $(IMAGE_SIZE); \
		sudo modprobe nbd; \
		sudo qemu-nbd --connect=/dev/nbd0 $(IMAGE_FILE); \
		sudo parted /dev/nbd0 mklabel msdos; \
		sudo parted /dev/nbd0 mkpart primary ext4 1MiB 100%; \
		sudo mkfs.ext4 /dev/nbd0p1; \
		sudo qemu-nbd --disconnect /dev/nbd0; \
	else \
		echo $(IMAGE_FILE) file already exists; \
	fi

$(ROOTFS_FILE): $(CACHE_DIR)
	if [ ! -f $(ROOTFS_FILE) ]; then \
		echo "Downloading rootfs file..."; \
		set -e; curl -o $(ROOTFS_FILE) $(ROOTFS_URL); \
	else \
		echo $(ROOTFS_FILE) already exists; \
	fi

rootfs-image: $(ROOTFS_IMG)

$(ROOTFS_IMG): $(ROOTFS_FILE) $(BUILD_DIR) $(DUMB_INIT_BIN) $(IMAGE_FILE) $(CARL_EXIT_BIN) $(INIT_SH)
	sudo modprobe nbd
	if grep -qs $(ROOTFS_PATH) /proc/mounts; then \
		sudo umount $(ROOTFS_PATH); \
	fi
	if [ -d $(ROOTFS_PATH) ]; then \
		rmdir $(ROOTFS_PATH); \
	fi
	sudo qemu-nbd --disconnect /dev/nbd0
	set -x; sudo qemu-nbd --connect=/dev/nbd0 $(IMAGE_FILE)
	mkdir -p $(ROOTFS_PATH)
	set -e -x;sudo mount /dev/nbd0p1 $(ROOTFS_PATH)
	sudo tar -xf $(ROOTFS_FILE) -C $(ROOTFS_PATH)
	sudo cp $(DUMB_INIT_BIN) $(ROOTFS_PATH)/dumb-init
	sudo chmod +x $(ROOTFS_PATH)/dumb-init
	sudo cp $(CARL_EXIT_BIN) $(ROOTFS_PATH)/carl-exit
	sudo chmod +x $(ROOTFS_PATH)/carl-exit
	sudo cp $(INIT_SH) $(SBIN_INIT)
	sudo chmod +x $(SBIN_INIT)
	sudo umount $(ROOTFS_PATH)
	sudo rmdir $(ROOTFS_PATH)
	sudo qemu-nbd --disconnect /dev/nbd0
	mv $(IMAGE_FILE) $(ROOTFS_IMG)

dumb-init: $(DUMB_INIT_BIN)

$(DUMB_INIT_BIN): $(DUMB_INIT_SRC)
	musl-gcc --static -o $(DUMB_INIT_BIN) $(DUMB_INIT_SRC)/dumb-init.c

$(CARL_EXIT_BIN): $(CARL_EXIT_SRC)
	nasm -felf64 $(CARL_EXIT_SRC)/carl-exit.asm -o $(BUILD_DIR)/carl-exit.o
	ld -z noseparate-code -s -static -nostdlib -o $(CARL_EXIT_BIN) $(BUILD_DIR)/carl-exit.o
	strip $(CARL_EXIT_BIN)

$(ROOTFS_PATH): $(ROOTFS_FILE) $(IMAGE_FILE) mount
	sudo tar -xzf $(ROOTFS_FILE) -C $(ROOTFS_PATH)

root-image-mount: $(ROOTFS_IMG)
	sudo modprobe nbd
	if grep -qs $(ROOTFS_PATH) /proc/mounts; then \
		sudo umount $(ROOTFS_PATH); \
	fi
	if [ -d $(ROOTFS_PATH) ]; then \
		rmdir $(ROOTFS_PATH); \
	fi
	sudo qemu-nbd --disconnect /dev/nbd0
	sudo qemu-nbd --connect=/dev/nbd0 $(ROOTFS_IMG)
	mkdir -p $(ROOTFS_PATH)
	sudo mount /dev/nbd0p1 $(ROOTFS_PATH)


# mount: $(ROOTFS_PATH)
# 	if ! grep -qs $(ROOTFS_PATH) /proc/mounts; then \
# 		sudo modprobe nbd; \
# 		sudo qemu-nbd --connect=/dev/nbd0 $(IMAGE_FILE); \
# 		mkdir -p $(ROOTFS_PATH); \
# 		sudo mount /dev/nbd0p1 $(ROOTFS_PATH); \
# 	fi

umount:
	# check if mountedls
	if grep -qs $(ROOTFS_PATH) /proc/mounts; then \
		echo "Unmounting rootfs..."; \
		sudo umount $(ROOTFS_PATH); \
	fi
	sudo qemu-nbd --disconnect /dev/nbd0
	set -ex; sudo modprobe -r nbd
	rm -rf $(ROOTFS_PATH)

chroot-shell: $(ROOTFS_PATH)
	sudo chroot $(ROOTFS_PATH) /bin/sh

# set -e; curl -o $(CARLVM_FILE) $(CARLVM_URL); \

# $(CARLVM_FILE):
# 	if [ ! -f $(CARLVM_FILE) ]; then \
# 		echo "Downloading carlvm file..."; \
# 		cp /tmp/act_artifacts/1/carl.vm/carl.vm.zip $(CARLVM_FILE); \
# 	else \
# 		echo "Carlvm file already exists"; \
# 	fi

# $(CARLVM_DIR): $(CARLVM_FILE)
# 	mkdir -p $(CARLVM_DIR)
# 	cp $(CARLVM_FILE) $(CARLVM_DIR)/vm.zip
# 	cd $(CARLVM_DIR) && ls -la && unzip vm.zip && ls -la
# 	tail -n +15 $(CARLVM_DIR)/carl.vm > $(CARLVM_DIR)/stripped.zip
# 	cd $(CARLVM_DIR) && ls -la && unzip stripped.zip && ls -la



# -net nic,model=virtio \
# -net user,hostfwd=tcp::10022-:22 \
# -drive file=$(IMAGE_FILE),format=qcow2 \
# -initrd $(CARLVM_DIR)/alpine-minirootfs-3.20.3-x86_64.cpio
# -append "root=/dev/vda1 console=ttyS0 init=/dumb-init /bin/sh"

.PHONY: carlvm
carlvm: $(KERNEL_BZIMAGE) $(ROOTFS_IMG)
	qemu-system-x86_64 \
		-m 2G \
		-cpu host \
		-smp 2 \
		-enable-kvm \
		-drive file=$(ROOTFS_IMG),media=disk,if=virtio,cache=writeback \
		-nographic \
		-kernel $(KERNEL_BZIMAGE) \
		-append "root=/dev/vda1 console=ttyS0"

# mkdir /mnt/vda1 
# mount /dev/vda1 /mnt/vda1/
# cat /mnt/vda1/etc/os-release 

clean: umount
	rm -rf $(BUILD_DIR)

chroot:
	if ! grep -qs $(ROOTFS_PATH) /proc/mounts; then \
		sudo modprobe nbd; \
		sudo qemu-nbd --connect=/dev/nbd0 $(IMAGE_FILE); \
		sudo mount /dev/nbd0p1 $(ROOTFS_PATH); \
	fi
	# sudo mount --bind /dev $(ROOTFS_PATH)/dev
	# sudo mount --bind /proc $(ROOTFS_PATH)/proc
	# sudo mount --bind /sys $(ROOTFS_PATH)/sys
	sudo chroot $(ROOTFS_PATH) /bin/sh
	# sudo umount $(ROOTFS_PATH)/dev
	# sudo umount $(ROOTFS_PATH)/proc
	# sudo umount $(ROOTFS_PATH)/sys
	sudo umount $(ROOTFS_PATH)
	sudo qemu-nbd --disconnect /dev/nbd0
	rm -rf $(ROOTFS_PATH)


$(BASEISO_FILE): $(CACHE_DIR)
	if [ ! -f $(BASEISO_FILE) ]; then \
		echo "Downloading Chimera base iso..."; \
		set -e; curl -o $(BASEISO_FILE) $(BASEISO_URL); \
	else \
		echo "Chimera base iso already exists"; \
	fi

# -kernel $(KERNEL_BZIMAGE) \
# -append "root=/dev/sda console=ttyS0 init=/bin/sh" \

$(BASEFULL_IMAGE):
	if [ ! -f $(BASEFULL_IMAGE) ]; then \
		echo "Creating image file..."; \
		set -e;	qemu-img create -f qcow2 $(BASEFULL_IMAGE) "10g"; \
		sudo modprobe nbd; \
		sudo qemu-nbd --connect=/dev/nbd0 $(BASEFULL_IMAGE); \
		sudo parted /dev/nbd0 mklabel msdos; \
		sudo parted /dev/nbd0 mkpart primary ext4 1MiB 100%; \
		sudo mkfs.ext4 /dev/nbd0p1; \
		sudo qemu-nbd --disconnect /dev/nbd0; \
	else \
		echo $(BASEFULL_IMAGE) file already exists; \
	fi

$(BASETINY_IMAGE):
	if [ ! -f $(BASETINY_IMAGE) ]; then \
		rm -f $(BASETINY_IMAGE); \
	fi
	echo creating $(BASETINY_IMAGE)
	set -e;	qemu-img create -f qcow2 $(BASETINY_IMAGE) "512M"
	sudo modprobe nbd
	sudo qemu-nbd --connect=/dev/nbd0 $(BASETINY_IMAGE)
	sudo parted /dev/nbd0 mklabel msdos
	sudo parted /dev/nbd0 mkpart primary ext4 1MiB 100%
	sudo mkfs.ext4 /dev/nbd0p1
	sudo qemu-nbd --disconnect /dev/nbd0

chimera: $(BASEISO_FILE) $(BASEFULL_IMAGE)
	qemu-system-x86_64 \
		-m 2G \
		-cpu host \
		-smp 2 \
		-enable-kvm \
		-drive file=$(BASEFULL_IMAGE),media=disk,if=virtio,cache=writeback \
        -drive file=$(BASEISO_FILE),media=cdrom,index=0,readonly=on,if=ide \
		-boot d

# mkdir /mnt/vda1
# mount /dev/vda1 /mnt/vda1/
# chimera-bootstrap /mnt/vda1
# chimera-chroot /mnt/vda1
# # in chroot
# apk add linux-lts grub-i386-pc
# genfstab / >> /etc/fstab
# update-initramfs -c -k all
# grub-install /dev/vda
# passwd

chimera2: $(BASEFULL_IMAGE) $(BASETINY_IMAGE)
	qemu-system-x86_64 \
		-m 2G \
		-cpu host \
		-smp 2 \
		-net nic,model=virtio \
		-net user,hostfwd=tcp::10022-:22 \
		-drive file=$(BASEFULL_IMAGE),media=disk,if=virtio,cache=writeback \
		-drive file=$(BASETINY_IMAGE),media=disk,if=virtio,cache=writeback \
		-enable-kvm \
		-nographic

chimera3:
	qemu-system-x86_64 \
		-m 64M \
		-cpu host \
		-smp 2 \
		-drive file=$(BASETINY_IMAGE),media=disk,if=virtio,cache=writeback \
		-enable-kvm \
		-kernel $(KERNEL_BZIMAGE) \
		-append "root=/dev/vda1 console=ttyS0 init=/bin/sh" \
		-nographic	


chimera4: $(ROOTFS_IMG)
	qemu-system-x86_64 \
		-m 64M \
		-cpu host \
		-smp 2 \
		-drive file=$(ROOTFS_IMG),media=disk,if=virtio,cache=writeback \
		-enable-kvm \
		-kernel $(KERNEL_BZIMAGE) \
		-append "root=/dev/vda1 console=ttyS0 init=/dumb-init -- /sbin/init" \
		-nographic