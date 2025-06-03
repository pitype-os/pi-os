#!/bin/bash
qemu-system-riscv64 -machine virt -nographic -bios none -kernel ./kernel.elf -serial mon:stdio
