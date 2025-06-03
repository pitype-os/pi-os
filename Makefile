CC := riscv64-unknown-elf-gcc
IDRIS2_CC =: riscv64-unknown-elf-gcc 
CFLAGS=-fno-builtin -Wno-pointer-to-int-cast -c -mcmodel=medany

BOOTDIR = boot
BOOTSOURCES := $(shell find $(BOOTDIR) -name '*.s')
BOOTOBJS:= $(BOOTSOURCES:%.s=%.o)

IDRIS_LIB= $(shell pack data-path)/urefc

all:
	$(MAKE) -C boot/
	IDRIS2_CC=$(CC) IDRIS2_CFLAGS="$(CFLAGS)" pack build pi.ipkg
	riscv64-unknown-elf-ld -T boot/linker.ld -L$(IDRIS_LIB) -nostdlib build/exec/kernel.o  $(BOOTOBJS) -lidris2_urefc -o kernel.elf

kernel:
	$(CC) $(CFLAGS) -I$(IDRIS_LIB) build/exec/kernel.c -c -o build/exec/kernel.o

watch:
	find ./ -iname "*.idr" | entr -sndc 'make && ./boot.bash'

clean:
	$(MAKE) clean -C boot
	rm -rf build/
	rm -f *.o *.elf *.c || true
