# =========================================================
# targets.mk - Definición de objetivos de compilación
# =========================================================

.PHONY: all image run clean TRBL # Objetivos principales

all: image


CreateDirs: clean
	mkdir -p $(BUILD_STG1_FOLDER)
	mkdir -p $(BUILD_STG2_FOLDER)
	mkdir -p $(BUILD_STG3_FOLDER)
	mkdir -p $(BUILD_K32_FOLDER)
	mkdir -p $(BUILD_K_FOLDER)

CompileASM: CreateDirs
	$(ASM) -f bin $(STG1) -o $(BUILD_STG1)
	$(ASM) -f bin $(STG2) -o $(BUILD_STG2)
	$(ASM) -f bin $(STG3) -o $(BUILD_STG3)
#	$(ASM) -f bin $(K32) -o $(BUILD_K32)


image: CompileASM

	$(DD) if=/dev/zero of=build/os.img bs=512 count=128
	$(DD) if=$(BUILD_STG1) of=build/os.img seek=0 conv=notrunc 
	$(DD) if=$(BUILD_STG2) of=build/os.img seek=1 conv=notrunc 
	$(DD) if=$(BUILD_STG3) of=build/os.img seek=2 conv=notrunc 
#   $(DD) if=$(BUILD_K32) of=build/os.img seek=7 conv=notrunc
run:
	$(QEMU) -drive format=raw,file=build/os.img

clean:
	rm -rf $(BUILD)

TRBL: clean all run 
