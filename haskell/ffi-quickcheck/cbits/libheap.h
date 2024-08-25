/* stolen from https://www.youtube.com/watch?v=sZ8GJ1TiMdk */
#include <stdio.h>

#define HEAP_SIZE 640 * 1024

void *heap_alloc(size_t size);

void heap_free(void *ptr);

void heap_collect();