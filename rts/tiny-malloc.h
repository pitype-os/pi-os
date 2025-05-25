#pragma once 

#ifdef __xstormy16__
#define MALLOC_DIRECTION -1
#endif

#ifndef MALLOC_DIRECTION
#define MALLOC_DIRECTION 1
#endif

#include <stddef.h>
#include "libc.h"

void* malloc(size_t);
void    free(void*);
void* realloc(void*, size_t);
void* memalign(size_t, size_t);
void* valloc(size_t);
void* pvalloc(size_t);
void* calloc(size_t, size_t);
void    cfree(void*);
int     malloc_trim(size_t);
size_t  malloc_usable_size(void*);
void    malloc_stats(void);
int     mallopt(int, int);
struct mallinfo mallinfo(void);

typedef struct freelist_entry {
  size_t size;
  struct freelist_entry *next;
} *fle;


