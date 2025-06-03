CC := riscv64-unknown-elf-gcc
IDRIS2_CC =: riscv64-unknown-elf-gcc 
CFLAGS=-fno-builtin -Wno-pointer-to-int-cast -c -mcmodel=medany

PCBOOTDIR = pcboot
PCBOOTSOURCES := $(shell find $(PCBOOTDIR) -name '*.s')
PCBOOTOBJS:= $(PCBOOTSOURCES:%.s=%.o)

IDRIS_LIB= $(shell pack data-path)/urefc

all:
	$(MAKE) -C pcboot/
	IDRIS2_CC=$(CC) IDRIS2_CFLAGS="$(CFLAGS)" pack build pi.ipkg
	riscv64-unknown-elf-ld -T pcboot/linker.ld -L$(IDRIS_LIB) -nostdlib build/exec/kernel.o  $(PCBOOTOBJS) -lidris2_urefc -o kernel.elf
clean:
	$(MAKE) clean -C pcboot
	rm -rf build/
	rm -f *.o *.elf *.c || true

boot:
	qemu-system-riscv64 -machine virt -nographic -bios none -kernel ./kernel.elf -serial mon:stdio
