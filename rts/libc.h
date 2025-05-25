#pragma once 

#include <stddef.h>

int abs(int j);
int isdigit(int c);
void *memcpy(void *d, const void *s, size_t n);
void *memmove(void* d, void* s, size_t n);
void *memset(void *d, int c, size_t n);
int strcmp(const char *s1, const char *s2);
char *strncpy(char *dest, const char *src, size_t n);
size_t strnlen(const char *s, size_t maxlen);
size_t strlen(const char *s);
double atof_hop(char *s);
int atoi(char* str);




