#include "cBackend.h"

// IORef

Value *newIORef(Value *, Value *, Value *);
Value *readIORef(Value *, Value *, Value *);
Value *writeIORef(Value *, Value *, Value *, Value *);

// Sys

Value *sysCodegen(void);
Value *idris2_crash(Value *msg);

// Array

Value *newArray(Value *, Value *, Value *, Value *);
Value *arrayGet(Value *, Value *, Value *, Value *);
Value *arraySet(Value *, Value *, Value *, Value *, Value *);

void idris_primitive_memcpy(void *dst, ptrdiff_t doff, void *src, ptrdiff_t soff, size_t len);
void idris_primitive_memmove(void *dst, ptrdiff_t doff, void *src, ptrdiff_t soff, size_t len);

int idris2_isNull(void *);
void *idris2_getNull();

Bits8* idris2_plusAddr_Bits8(Bits8 *p, Bits32 offset);
Bits16* idris2_plusAddr_Bits16(Bits16 *p, Bits32 offset);
Bits32* idris2_plusAddr_Bits32(Bits32 *p, Bits32 offset);
Bits64* idris2_plusAddr_Bits64(Bits64 *p, Bits32 offset);
Ptr* idris2_plusAddr_Ptr(Value* var_1, Ptr *p, Bits32 offset);
Double* idris2_plusAddr_Double(Double *p, Bits32 offset);
Char* idris2_plusAddr_Char(Char *p, Bits32 offset);

size_t idris2_sizeOf_Bits8();
size_t idris2_sizeOf_Bits16();
size_t idris2_sizeOf_Bits32();
size_t idris2_sizeOf_Bits64();
size_t idris2_sizeOf_Ptr();
size_t idris2_sizeOf_Double();
size_t idris2_sizeOf_Char();

void idris2_primitive_memset_Bits8(Bits8 *, ptrdiff_t, size_t, Bits8);
void idris2_primitive_memset_Bits16(Bits16 *, ptrdiff_t, size_t, Bits16);
void idris2_primitive_memset_Bits32(Bits32 *, ptrdiff_t, size_t, Bits32);
void idris2_primitive_memset_Bits64(Bits64 *, ptrdiff_t, size_t, Bits64);
void idris2_primitive_memset_Ptr(Ptr *, ptrdiff_t, size_t, Ptr);
void idris2_primitive_memset_Double(Double *, ptrdiff_t, size_t, Double);
void idris2_primitive_memset_Char(Char *, ptrdiff_t, size_t, Char);

Bits8 idris2_readAddr_Bits8(Bits8 *p);
Bits16 idris2_readAddr_Bits16(Bits16 *p);
Bits32 idris2_readAddr_Bits32(Bits32 *p);
Bits64 idris2_readAddr_Bits64(Bits64 *p);
Double idris2_readAddr_Double(Double *p);
Char idris2_readAddr_Char(Char *p);

Value *onCollect(Value *, Value *, Value *, Value *);
Value *onCollectAny(Value *, Value *, Value *);

Value *voidElim(Value *, Value *);

extern size_t HEAP_SIZE;
size_t idris2_heap_size();

extern char* HEAP_START;
char* idris2_heap_start();



