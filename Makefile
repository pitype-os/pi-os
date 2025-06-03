IDRIS_LIB= $(shell pack data-path)/urefc
IDRIS_SUPPORT=cBits

CC := riscv64-unknown-elf-gcc
CFLAGS=-fno-builtin -Wno-pointer-to-int-cast -c -mcmodel=medany -I$(IDRIS_LIB) -I$(IDRIS_SUPPORT)

BOOTDIR = boot
BOOTSOURCES := $(shell find $(BOOTDIR) -name '*.s')
BOOTOBJS:= $(BOOTSOURCES:%.s=%.o)

all:
	$(MAKE) -C boot/
	$(MAKE) -C cBits/
	IDRIS2_CC=$(CC) IDRIS2_CFLAGS="$(CFLAGS)" pack build pi.ipkg
	riscv64-unknown-elf-ld -T boot/linker.ld -L$(IDRIS_LIB) -L$(IDRIS_SUPPORT) -nostdlib build/exec/kernel.o  $(BOOTOBJS) -lidris2_urefc -lidris_support -o kernel.elf
 
kernel:
	$(CC) $(CFLAGS) build/exec/kernel.c -c -o build/exec/kernel.o

watch:
	find ./ -iname "*.idr" | entr -sndc 'make && ./boot.bash'

clean:
	$(MAKE) clean -C boot
	$(MAKE) clean -C cBits
	rm -rf build/
	rm -f *.o *.elf *.c || true
