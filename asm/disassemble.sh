#!/bin/sh

echo "Script to disassemble the RISC-V assembly code stored in isa_test.s"

riscv32-unknown-elf-as -o isa_test.o -c isa_test.S 
riscv32-unknown-elf-objdump -d isa_test.o 
riscv32-unknown-elf-objdump -d isa_test.o > disassemble.txt
