# Default image name
IMAGE_NAME ?= mkinitfs-image

# Build the Docker image
build: .docker-image

.docker-image: Dockerfile
	docker build -t $(IMAGE_NAME) .
	touch .docker-image

# Ensure the output directory exists and has the correct permissions
prepare-output-dir: build
	mkdir -p output
	sudo chown $(shell id -u):$(shell id -g) output

# Run the Docker container with an interactive shell and volume mount
shell: prepare-output-dir
	docker run --rm -it -v $(PWD)/output:/build --user $(shell id -u):$(shell id -g) $(IMAGE_NAME) sh

# Run the Docker container and generate the cpio file
run: build prepare-output-dir
	docker run --rm -it -v $(PWD)/output:/build --user $(shell id -u):$(shell id -g) $(IMAGE_NAME)

.PHONY: build shell run prepare-output-dir