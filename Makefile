CC := riscv64-unknown-elf-gcc 
CFLAGS=-fno-builtin -Wno-pointer-to-int-cast -Wall -Wextra -c -mcmodel=medany

RTSDIR = rts
RTSSOURCES := $(shell find $(RTSDIR) -name '*.c')
RTSOBJS:= $(RTSSOURCES:%.c=%.o)

PCBOOTDIR = pcboot
PCBOOTSOURCES := $(shell find $(PCBOOTDIR) -name '*.s')
PCBOOTOBJS:= $(PCBOOTSOURCES:%.s=%.o)

all:
	$(MAKE) -C rts/
	$(MAKE) -C pcboot/
	pack build pi.ipkg
	sed -i='' 's/#include <runtime.h>/#include "..\/..\/rts\/runtime.h"\n/g' build/exec/kernel.c
	sed -i='' 's/#include <idris_support.h>//g' build/exec/kernel.c
	sed -i='' 's/int main(int argc, char \*argv\[\])/int kmain\(\)/g' build/exec/kernel.c
	sed -i='' 's/idris2_setArgs(argc, argv);//g' build/exec/kernel.c
	${CC} ${CFLAGS} build/exec/kernel.c -o build/exec/kernel.o -ffreestanding
	riscv64-unknown-elf-ld -T pcboot/linker.ld -nostdlib build/exec/kernel.o  $(PCBOOTOBJS) $(RTSOBJS) -o kernel.elf
clean:
	$(MAKE) clean -C rts
	$(MAKE) clean -C pcboot
	rm -rf build/
	rm -f *.o *.elf *.c || true

boot:
	qemu-system-riscv64 -machine virt -nographic -bios none -kernel ./kernel.elf -serial mon:stdio
