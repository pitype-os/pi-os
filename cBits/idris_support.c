#include "idris_support.h"

// POINTER OPERATIONS

int idris2_isNull(void *ptr) { return (ptr == NULL); }
void *idris2_getNull() { return NULL; }

Value* idris2_anyptr_nat(void *p) {
	Value_Integer *retVal = idris2_mkInteger();
	mpz_set_si(retVal->i,p);
	return (Value *)retVal;
}

// MEMORY OPERATIONS

size_t idris2_heap_size() { return HEAP_SIZE; }
size_t idris2_heap_start() { return HEAP_START; }

// utils

char *UART=(char*) 0x10000000;

void putChar(char c) {
	*UART=c;
}

void print(char *str) {
	while(*str!='\0') {
		putChar(*str);
		str++;
	}

	putChar('\n');
}

