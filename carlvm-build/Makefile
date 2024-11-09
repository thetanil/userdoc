BUILD_DIR := $(shell pwd)/build
IMAGE_FILE := $(BUILD_DIR)/disk.qcow2
IMAGE_SIZE := "1G"
ROOTFS_PATH := $(BUILD_DIR)/rootfs
ROOTFS_FILE := $(BUILD_DIR)/rootfs.tar.gz
ROOTFS_URL := "https://repo.chimera-linux.org/live/latest/chimera-linux-x86_64-ROOTFS-20241027-bootstrap.tar.gz"
CARLVM_DIR := $(BUILD_DIR)/carlvm
CARLVM_FILE := $(BUILD_DIR)/carlvm.zip
CARLVM_URL := "https://github.com/thetanil/userdoc/releases/latest/download/carl.vm"

all: $(IMAGE_FILE) $(ROOTFS_PATH)

$(IMAGE_FILE):
	qemu-img create -f qcow2 $(IMAGE_FILE) $(IMAGE_SIZE)

$(ROOTFS_FILE):
	if [ ! -f $(ROOTFS_FILE) ]; then \
		echo "Downloading rootfs file..."; \
		set -e; curl -o $(ROOTFS_FILE) $(ROOTFS_URL); \
	else \
		echo "Rootfs file already exists"; \
	fi

$(ROOTFS_PATH): $(ROOTFS_FILE) $(IMAGE_FILE)
	mkdir -p $(ROOTFS_PATH)
	sudo modprobe nbd
	sudo qemu-nbd --connect=/dev/nbd0 $(IMAGE_FILE)
	sudo parted /dev/nbd0 mklabel msdos
	sudo parted /dev/nbd0 mkpart primary ext4 1MiB 100%
	sudo mkfs.ext4 /dev/nbd0p1
	sudo mount /dev/nbd0p1 $(ROOTFS_PATH)
	sudo touch $(ROOTFS_PATH)/.carl_was_here
	sudo tar -xzf $(ROOTFS_FILE) -C $(ROOTFS_PATH)

umount:
	# check if mountedls
	if grep -qs $(ROOTFS_PATH) /proc/mounts; then \
		echo "Unmounting rootfs..."; \
		sudo umount $(ROOTFS_PATH); \
	fi
	sudo qemu-nbd --disconnect /dev/nbd0
	rm -rf $(ROOTFS_PATH)

chroot-shell: $(ROOTFS_PATH)
	sudo chroot $(ROOTFS_PATH) /bin/sh

$(CARLVM_FILE):
	if [ ! -f $(CARLVM_FILE) ]; then \
		echo "Downloading carlvm file..."; \
		set -e; curl -o $(CARLVM_FILE) $(CARLVM_URL); \
	else \
		echo "Carlvm file already exists"; \
	fi

$(CARLVM_DIR): $(CARLVM_FILE)
	mkdir -p $(CARLVM_DIR)
	unzip $(CARLVM_FILE) -d $(CARLVM_DIR)

# -net nic,model=virtio \
# -net user,hostfwd=tcp::10022-:22 \

carlvm: $(CARLVM_DIR) umount
	qemu-system-x86_64 \
		-m 2G \
		-cpu host \
		-smp 2 \
		-enable-kvm \
		-drive file=$(IMAGE_FILE),format=qcow2 \
		-nographic \
		-kernel $(CARLVM_DIR)/bzImage \
		-append "root=/dev/vda1 console=ttyS0" \
		-initrd $(CARLVM_DIR)/initramfs.cpio

clean: umount
	rm -f $(IMAGE_FILE) 
	# rm -f $(ROOTFS_FILE)
	rm -rf $(ROOTFS_PATH)
