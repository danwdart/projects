/* Stolen from John Hughes and altered for my own evil purposes */

#include <assert.h>
#include <stdlib.h>
#include "queue.h"

Queue *new(int n) {
    assert(("Length of queue must be greater than 0", n > 0)); /* how can haskell catch that? can it even? */
    int *buff = malloc(n * sizeof(int));
    Queue q = {0, 0, n, buff};
    Queue *qptr = malloc(sizeof(Queue));
    *qptr = q;
    return qptr;
}

void put(Queue *q, int n) {
    q->buf[q->inp] = n;
    q->inp = (q->inp + 1) % q->size;
}

int get(Queue *q) {
    int ans = q->buf[q->outp];
    q->outp = (q->outp + 1) % q->size;
    return ans;
}

int size(Queue *q) {
    return (q->inp - q->outp) % q->size;
}