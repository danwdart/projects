module Data.Queue.FFI where

-- This is how to export.
data Queue = Queue {
    inp  :: Int,
    outp :: Int,
    size :: Int,
    buf  :: [Int]
} deriving Show

-- Implement in Haskell
mkQueue :: Int → Queue
mkQueue = undefined

put :: Queue → Int → Queue
put = undefined
{-
q->buf[q->inp] = n;
    q->inp = (q->inp + 1) % q->size;
-}

get :: Queue → Int
get = undefined
{-
    int ans = q->buf[q->outp];
    q->outp = (q->outp + 1) % q->size;
    return ans;
-}

getSize :: Queue → Int
getSize = undefined
{-
return (q->inp - q->outp) % q->size;
-}
