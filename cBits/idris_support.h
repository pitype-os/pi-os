#include <runtime.h>

// POINTER OPERATIONS
int idris2_isNull(void *);
void *idris2_getNull();

// MEMORY OPERATIONS
extern size_t HEAP_SIZE;
size_t idris2_heap_size();

extern size_t HEAP_START;
size_t idris2_heap_start();

// utils
void print(char *str);
char* itoa(int value, char* result, int base);

