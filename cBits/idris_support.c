#include "idris_support.h"

// POINTER OPERATIONS

int idris2_isNull(void *ptr) { return (ptr == NULL); }
void *idris2_getNull() { return NULL; }

#define PLUSADDR(TYPE) TYPE* idris2_plusAddr_ ## TYPE (TYPE *p, Bits32 offset) { p += offset; return p;}
PLUSADDR(Bits8)
PLUSADDR(Bits16)
PLUSADDR(Bits32)
PLUSADDR(Bits64)
PLUSADDR(Double)
PLUSADDR(Char)

#define SIZEOF(TYPE) size_t idris2_sizeOf_ ## TYPE () { return sizeof(TYPE); }
SIZEOF(Bits8)
SIZEOF(Bits16)
SIZEOF(Bits32)
SIZEOF(Bits64)
SIZEOF(Double)
SIZEOF(Char)

#define MEMSET(TYPE) void idris2_primitive_memset_ ## TYPE (TYPE *p, ptrdiff_t off, size_t n, TYPE x) { p += off; *p=x;}
MEMSET(Bits8)
MEMSET(Bits16)
MEMSET(Bits32)
MEMSET(Bits64)
MEMSET(Double)
MEMSET(Char)

#define READADDR(TYPE) TYPE idris2_readAddr_ ## TYPE (TYPE *p){ return *p; }
READADDR(Bits8)
READADDR(Bits16)
READADDR(Bits32)
READADDR(Bits64)
READADDR(Double)
READADDR(Char)

// MEMORY OPERATIONS

size_t idris2_heap_size() { return HEAP_SIZE; }
char* idris2_heap_start() { return HEAP_START; }
