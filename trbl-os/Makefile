.PHONY: boot os remove ERASE help

# Variables
CARGO = cargo
NASM = nasm
QEMU_IMG = qemu-img
DD = dd
VBOX = VBoxManage
CLEAR = clear
OS_IMAGE = trbl-os.img
VDI_IMAGE = trbl-os.vdi
BINARY = trbl-os.bin
BOOT_BIN = boot/boot.bin

# Build bootloader and kernel
boot:
	@echo "Building bootloader and kernel..."
	@$(CARGO) bootimage
	@$(NASM) -f bin boot/boot.asm -o $(BOOT_BIN)
	@echo "Build completed!"

# Create OS image files
os: boot
	@echo "Creating Main Binary..."
	@echo "Done!"
	@echo "Converting to QEMU image..."
	@$(QEMU_IMG) create -f raw $(OS_IMAGE) 10M
	@$(DD) if=target/x86_64-trbl_os/debug/bootimage-trbl-os.bin of=$(OS_IMAGE) conv=notrunc
	@echo "Done!"
	@echo "Creating VDI image..."
	@$(VBOX) convertdd $(OS_IMAGE) $(VDI_IMAGE) --format VDI
	@echo "Done! OS image created successfully!"

# Remove generated image files
remove:
	@echo "Removing image files..."
	@rm -f $(OS_IMAGE) $(BINARY) $(VDI_IMAGE)
	@echo "Image files removed!"

# Full cleanup
ERASE: remove
	@echo "Cleaning build artifacts..."
	@$(CARGO) clean
	@rm -f $(BOOT_BIN) $(BINARY) $(OS_IMAGE) $(VDI_IMAGE)
	@echo "Full cleanup completed!"

# Run the OS in QEMU emulator
run-qemu:
	@echo "Running OS in QEMU..."
	@qemu-system-x86_64 -drive file=$(OS_IMAGE),format=raw
	@echo "QEMU session ended."


# Display help
help:
	@echo "=========================================="
	@echo "Makefile commands:"
	@echo "=========================================="
	@echo "  make boot    - Build the bootloader and kernel"
	@echo "  make remove  - Remove generated image files"
	@echo "  make os      - Create the OS image files"
	@echo "  make ERASE   - Full cleanup of build artifacts"
	@echo "  make help    - Display this help message"
	@echo "  make run-qemu - Run the OS in QEMU emulator"
	@echo "  make test    - Erase, compile, test"
	@echo "=========================================="

# Test: Clean, build, and run
test:
	@make ERASE
	@make os
	@make run-qemu




bootimage:
	@$(QEMU_IMG) create -f raw bootimage-trbl-os.bin 10M
	@$(DD) if=trbl-os.bin of=bootimage-trbl-os.bin conv=notrunc
	@$(VBOX) convertdd trbl-os.img trbl-os.vdi --format VDI
	@$(CLEAR)


















