AS := riscv64-unknown-elf-as 

CBITSDIR=./
CBITSSOURCES := $(shell find $(CBITSDIR) -name '*.s')
CBITSOBJS:= $(CBITSSOURCES:%.s=%.o)

all: cbits

cbits: $(CBITSOBJS)

CBITSDIR/entry.o: %.s

clean:
	rm -f *.o || true

