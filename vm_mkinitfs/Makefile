# Default image name
IMAGE_NAME ?= mkinitfs-image

# Alpine netboot image URL and file
ALPINE_NETBOOT_URL = http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-virt-3.20.3-x86_64.iso
NETBOOT_ISO = netboot.iso

# QEMU settings
QEMU_IMG = alpine.qcow2
QEMU_MEM = 2G
QEMU_CPUS = 1

# Ensure the output directory exists and has the correct permissions
prepare-output-dir:
	mkdir -p output
	sudo chown $(shell id -u):$(shell id -g) output

# Download Alpine netboot image if not already downloaded
$(NETBOOT_ISO):
	curl -L -o $(NETBOOT_ISO) $(ALPINE_NETBOOT_URL)

# Create QEMU image
create-qemu-img:
	qemu-img create -f qcow2 $(QEMU_IMG) 2G

# Run QEMU with Alpine netboot image
		# -net nic \
		# -net user,hostfwd=tcp::2222-:22
		# -hda $(QEMU_IMG) \
		# -nic user,model=virtio \
		# -display gtk \

run-qemu: $(NETBOOT_ISO) create-qemu-img
	qemu-system-x86_64 \
		-no-reboot \
		-no-user-config \
		-nodefaults \
		-cpu host \
		-enable-kvm \
		-m $(QEMU_MEM) \
		-smp $(QEMU_CPUS) \
		-cdrom $(NETBOOT_ISO) \
		-boot d \
		-hda alpine.qcow2 \
		-nographic \
		-serial mon:stdio

# SSH into the VM and run mkinitfs
run-mkinitfs: run-qemu
	@echo "Waiting for VM to boot..."
	@sleep 60
	@echo "Installing mkinitfs..."
	ssh -p 2222 -o "StrictHostKeyChecking no" root@localhost "apk add --no-cache mkinitfs"
	@echo "Running mkinitfs..."
	ssh -p 2222 -o "StrictHostKeyChecking no" root@localhost "mkinitfs -o /root/initramfs.cpio"
	@echo "Copying initramfs.cpio to host..."
	scp -P 2222 -o "StrictHostKeyChecking no" root@localhost:/root/initramfs.cpio output/

.PHONY: build prepare-output-dir download-netboot create-qemu-img run-qemu run-mkinitfs