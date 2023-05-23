#include <stdlib.h>

#ifndef _QUEUE_H
#define _QUEUE_H

typedef struct queue {
    int inp;
    int outp;
    int size;
    int *buf;
} Queue;

Queue *new(int n);

void put(Queue *q, int n);

int get(Queue *q);

int size(Queue *q);

#endif