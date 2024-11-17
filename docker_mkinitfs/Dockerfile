# Use an Alpine base image
FROM alpine:latest

# Install mkinitfs
# RUN apk update
RUN apk add --no-cache mkinitfs linux-headers

# Create a build directory
RUN mkdir -p /build

# Set the working directory
WORKDIR /build

# Copy the necessary files to the container
COPY . /build

# Run mkinitfs and write the cpio to the build directory
CMD ["sh", "-c", "mkinitfs -o /build/initramfs.cpio $(uname -r)"]