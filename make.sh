#!/bin/bash
# This is a comment

FILE=build
if [ -d "$FILE" ]; then
    echo "$FILE exists."
else 
    mkdir build
fi

echo Compiling ...
riscv64-unknown-elf-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -nostdlib -T eeprom.ld $1.S -o build/$1.elf
echo ELF to LST
riscv-nuclei-elf-objdump -S build/$1.elf > build/$1.lst
echo ELF to BIN
riscv-nuclei-elf-objcopy -O binary build/$1.elf build/$1.bin
echo ELF to LSS
riscv-nuclei-elf-objdump -D -S build/$1.elf > build/$1.lss
echo Flashing ...
#stm32flash -v -g 0x0 /dev/ttyUSB0 -w build/$1.bin
#echo Start ...
echo End ...

