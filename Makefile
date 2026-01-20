ASM = nasm
QEMU = qemu-system-x86_64

BUILD = build
BOOT = boot

all: image

$(BUILD):
	mkdir -p $(BUILD)

stage1: $(BUILD)
	$(ASM) -f bin $(BOOT)/stage1/stage1.asm -o $(BUILD)/stage1.bin

stage2_real: $(BUILD)
	$(ASM) -f bin $(BOOT)/stage2/real/stage2_real.asm -o $(BUILD)/stage2_real.bin

stage2_pm: $(BUILD)
	$(ASM) -f bin $(BOOT)/stage2/pm/stage2_pm.asm -o $(BUILD)/stage2_pm.bin

image: stage1 stage2_real stage2_pm
	dd if=/dev/zero of=$(BUILD)/os.img bs=512 count=10
	dd if=$(BUILD)/stage1.bin of=$(BUILD)/os.img conv=notrunc
	dd if=$(BUILD)/stage2_real.bin of=$(BUILD)/os.img seek=1 conv=notrunc
	dd if=$(BUILD)/stage2_pm.bin of=$(BUILD)/os.img seek=2 conv=notrunc

run:
	$(QEMU) -drive format=raw,file=$(BUILD)/os.img

clean:
	rm -rf $(BUILD)
