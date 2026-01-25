# ========================================================
# paths.mk - Definición de rutas y archivos de TRBL OS
# ========================================================

# Carpetas principales
# -----------------------------------------

BOOT := TRBL-bootloader # Carpeta raíz del bootloader

KERNEL := TRBL-kernel   # Carpeta raíz del kernel

ISO := iso              # Carpeta raíz de la imagen ISO

BUILD := build          # Carpeta raíz de build



# Archivos y carpetas del Bootloader
# -----------------------------------------

STG1_FOLDER := TRBL-bootloader/stage1 # Carpeta de stage1

STG1 := TRBL-bootloader/stage1/stage1.asm # Archivo de stage1.asm

STG2_FOLDER := TRBL-bootloader/stage2 # Carpeta de stage2

STG2 := TRBL-bootloader/stage2/stage2.asm # Archivo de stage2.asm

STG3_FOLDER := TRBL-bootloader/stage3 # Carpeta de stage3

STG3 := TRBL-bootloader/stage3/stage3.asm # Archivo de stage3.asm

STG4_FOLDER := TRBL-bootloader/stage4 # Carpeta de stage4

STG4 := TRBL-bootloader/stage4/stage4.asm # Archivo de stage4.asm



# Archivos y carpetas del Kernel
# -----------------------------------------

K32_FOLDER := TRBL-kernel/kernel32 # Carpeta de kernel32

K32 := TRBL-kernel/kernel32/kernel32.asm # Archivo de kernel32.asm

K_FOLDER := TRBL-kernel/kernel # Carpeta del kernel



# Archivos y carpetas de Build
# -----------------------------------------

BUILD_BOOT := build/TRBL-bootloader # Carpeta del bootloader en build

BUILD_STG1_FOLDER := build/TRBL-bootloader/stage1 # Carpeta de stage1 en build

BUILD_STG1 := build/TRBL-bootloader/stage1/stage1.bin # Archivo de stage1.bin

BUILD_STG2_FOLDER := build/TRBL-bootloader/stage2 # Carpeta de stage2 en build

BUILD_STG2 := build/TRBL-bootloader/stage2/stage2.bin # Archivo de stage2.bin

BUILD_STG3_FOLDER := build/TRBL-bootloader/stage3 # Carpeta de stage3 en build

BUILD_STG3 := build/TRBL-bootloader/stage3/stage3.bin # Archivo de stage3.bin

BUILD_STG4_FOLDER := build/TRBL-bootloader/stage4 # Carpeta de stage4 en build

BUILD_STG4 := build/TRBL-bootloader/stage4/stage4.bin # Archivo de stage4.bin

BUILD_KERNEL := build/TRBL-kernel # Carpeta del kernel en build

BUILD_K32_FOLDER := build/TRBL-kernel/kernel32 # Carpeta de kernel32 en build

BUILD_K32 := build/TRBL-kernel/kernel32/kernel32.bin # Archivo de kernel32

BUILD_K_FOLDER := build/TRBL-kernel/kernel

OS_IMAGE := build/os.img # Archivo de imagen del sistema operativo





















