#include "prim.h"

Value *idris2_Data_IORef_prim__newIORef(Value *erased, Value *input_value,
                                        Value *_world) {
  Value_IORef *ioRef = IDRIS2_NEW_VALUE(Value_IORef);
  ioRef->header.tag = IOREF_TAG;
  ioRef->v = idris2_newReference(input_value);
  return (Value *)ioRef;
}

Value *idris2_Data_IORef_prim__writeIORef(Value *erased, Value *_ioref,
                                          Value *new_value, Value *_world) {
  Value_IORef *ioref = (Value_IORef *)_ioref;
  idris2_newReference(new_value);
  Value *old = ioref->v;
  ioref->v = new_value;
  idris2_removeReference(old);
  return NULL;
}

// -----------------------------------
//       System operations
// -----------------------------------


Value *sysCodegen(void) { return (Value *)idris2_mkString("refc"); }

Value *idris2_crash(Value *msg) {
  Value_String *str = (Value_String *)msg;
//  print(str->str);
  exit(-1);
}

// // -----------------------------------
// //         Array operations
// // -----------------------------------


Value *idris2_Data_IOArray_Prims_prim__newArray(Value *erased, Value *_length,
                                                Value *v, Value *_word) {
  int length = idris2_vp_to_Int64(_length);
  Value_Array *a = idris2_makeArray(length);

  for (int i = 0; i < length; i++) {
    a->arr[i] = idris2_newReference(v);
  }

  return (Value *)a;
}

Value *idris2_Data_IOArray_Prims_prim__arraySet(Value *erased, Value *_array,
                                                Value *index, Value *v,
                                                Value *_word) {
  Value_Array *a = (Value_Array *)_array;
  idris2_removeReference(a->arr[idris2_vp_to_Int64(index)]);
  a->arr[idris2_vp_to_Int64(index)] = idris2_newReference(v);
  return NULL;
}

// -----------------------------------
//      Pointer operations
// -----------------------------------

void idris_primitive_memcpy( void *dst, ptrdiff_t doff, void *src, ptrdiff_t soff, size_t len )
{
  memcpy( (char *)dst + doff, (char *)src + soff, len );
}

void idris_primitive_memmove( void *dst, ptrdiff_t doff, void *src, ptrdiff_t soff, size_t len )
{
  memmove( (char *)dst + doff, (char *)src + soff, len );
}

int idris2_isNull(void *ptr) { return (ptr == NULL); }

void *idris2_getNull() { return NULL; }

#define PLUSADDR(TYPE)                                                  \
TYPE* idris2_plusAddr_ ## TYPE (TYPE *p, Bits32 offset) \
{ \
  p += offset; \
  return p; \
}

PLUSADDR(Bits8)
PLUSADDR(Bits16)
PLUSADDR(Bits32)
PLUSADDR(Bits64)
PLUSADDR(Double)
PLUSADDR(Char)

#define SIZEOF(TYPE)                                                  \
size_t idris2_sizeOf_ ## TYPE () \
{ \
  return sizeof(TYPE); \
}

SIZEOF(Bits8)
SIZEOF(Bits16)
SIZEOF(Bits32)
SIZEOF(Bits64)
SIZEOF(Double)
SIZEOF(Char)

#define MEMSET(TYPE)                                                  \
void idris2_primitive_memset_ ## TYPE (TYPE *p, ptrdiff_t off, size_t n, TYPE x) \
{ \
  p += off;                                                                  \
  if (x == 0)                                                                \
    memset(p, 0, n * sizeof(TYPE));                                          \
  else if (sizeof(TYPE) == sizeof(int)*2) {                                  \
    int *q = (int *)p;                                                       \
    const int *r = (const int *)(void *)&x;                                  \
    while (n>0) {                                                            \
      q[0] = r[0];                                                           \
      q[1] = r[1];                                                           \
      q += 2;                                                                \
      --n;                                                                   \
    }                                                                        \
  }                                                                          \
  else {                                                                     \
    while (n>0) {                                                            \
      *p++ = x;                                                              \
      --n;                                                                   \
    }                                                                        \
  }                                                                          \
}

MEMSET(Bits8)
MEMSET(Bits16)
MEMSET(Bits32)
MEMSET(Bits64)
MEMSET(Double)
MEMSET(Char)

#define READADDR(TYPE)                                                  \
TYPE idris2_readAddr_ ## TYPE (TYPE *p) \
{ \
  return *p; \
}

READADDR(Bits8)
READADDR(Bits16)
READADDR(Bits32)
READADDR(Bits64)
READADDR(Double)
READADDR(Char)

Value *idris2_Prelude_IO_prim__onCollect(Value *_erased, Value *_anyPtr,
                                         Value *_freeingFunction,
                                         Value *_world) {
  Value_GCPointer *retVal = IDRIS2_NEW_VALUE(Value_GCPointer);
  retVal->header.tag = GC_POINTER_TAG;
  retVal->p = (Value_Pointer *)idris2_newReference(_anyPtr);
  retVal->onCollectFct = (Value_Closure *)_freeingFunction;
  return (Value *)retVal;
}
 
Value *idris2_Prelude_IO_prim__onCollectAny(Value *_anyPtr,
                                            Value *_freeingFunction,
                                            Value *_world) {
  Value_GCPointer *retVal = IDRIS2_NEW_VALUE(Value_GCPointer);
  retVal->header.tag = GC_POINTER_TAG;
  retVal->p = (Value_Pointer *)idris2_newReference(_anyPtr);
  retVal->onCollectFct = (Value_Closure *)_freeingFunction;
  return (Value *)retVal;
}

Value *voidElim(Value *erased1, Value *erased2) { return NULL; }

size_t idris2_heap_size()
{
  return HEAP_SIZE;
}

char* idris2_heap_start()
{
  return HEAP_START;
}


