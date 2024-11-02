{-# LANGUAGE CApiFFI                  #-}
{-# LANGUAGE Unsafe                   #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-safe #-}

module Queue.Foreign where

import Foreign

-- can we import the struct - with c2hs or similar - we can generate it
data CQueue = CQueue {
    inp  :: Int,
    outp :: Int,
    size :: Int,
    buf  :: Ptr Int
}

-- TODO use ForeignPtr! CInt! Cmooooon... probably even unboxed ints.

foreign import capi "queue.h new" cqueue_new :: Int → IO (Ptr CQueue)
foreign import capi "queue.h put" cqueue_put :: Ptr CQueue → Int → IO ()
foreign import capi "queue.h get" cqueue_get :: Ptr CQueue → IO Int
foreign import capi "queue.h size" cqueue_size :: Ptr CQueue → IO Int

-- Now do we foreign import malloc? Probably not. We have Foreign.Marshal.Alloc for that!

-- Reimplement in Cstuff
queueNew :: Int → IO (Ptr CQueue)
queueNew = undefined
{-
assert(("Length of queue must be greater than 0", n > 0)); /* how can haskell catch that? can it even? */
    int *buff = malloc(n * sizeof(int));
    Queue q = {0, 0, n, buff};
    Queue *qptr = malloc(sizeof(Queue));
    *qptr = q;
    return qptr;
-}

queuePut :: Ptr CQueue → Int → IO ()
queuePut = undefined
{-
    q->buf[q->inp] = n;
    q->inp = (q->inp + 1) % q->size;
-}

queueGet :: Ptr CQueue → IO Int
queueGet = undefined
{-
    int ans = q->buf[q->outp];
    q->outp = (q->outp + 1) % q->size;
    return ans;
-}

queueSize :: Ptr CQueue → IO Int
queueSize = undefined
{-
return (q->inp - q->outp) % q->size;
-}