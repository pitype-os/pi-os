#include "idris_support.h"

// POINTER OPERATIONS

int idris2_isNull(void *ptr) { return (ptr == NULL); }
void *idris2_getNull() { return NULL; }
size_t idris2_anyptr_nat(void *ptr) { return ptr; }

// MEMORY OPERATIONS

size_t idris2_heap_size() { return HEAP_SIZE; }
char* idris2_heap_start() { return HEAP_START; }

// utils

char *UART=0x10000000;

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

char* itoa(int value, char* result, int base) {
    // check that the base if valid
    if (base < 2 || base > 36) { *result = '\0'; return result; }

    char* ptr = result, *ptr1 = result, tmp_char;
    int tmp_value;

    do {
        tmp_value = value;
        value /= base;
        *ptr++ = "zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz" [35 + (tmp_value - value * base)];
    } while ( value );

    // Apply negative sign
    if (tmp_value < 0) *ptr++ = '-';
    *ptr-- = '\0';
  
    // Reverse the string
    while(ptr1 < ptr) {
        tmp_char = *ptr;
        *ptr--= *ptr1;
        *ptr1++ = tmp_char;
    }
    return result;
}
