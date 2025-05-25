CC := riscv64-unknown-elf-gcc 

CFLAGS=-fno-builtin -Wno-pointer-to-int-cast -Wall -Wextra -c -mcmodel=medany
RTSDIR = ./
RTSSOURCES := $(shell find $(RTSDIR) -name '*.c')
RTSOBJS:= $(RTSSOURCES:%.c=%.o)

all:
	$(MAKE) rts

rts: $(RTSOBJS)

pc: $(PCOBJS)

rts/%.o: %.c

pc/%.o: %.s

clean:
	rm -f *.o || true

