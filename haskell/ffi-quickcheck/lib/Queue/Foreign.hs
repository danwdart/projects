{-# LANGUAGE CApiFFI                  #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE Unsafe                   #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-safe #-}

module Queue.Foreign where

import           Foreign

-- can we import the struct - with c2hs or similar - we can generate it
data CQueue = CQueue {
    inp  :: Int,
    outp :: Int,
    size :: Int,
    buf  :: Ptr Int
}

foreign import capi "queue.h new" queue_new :: Int → IO (Ptr CQueue)
foreign import capi "queue.h put" queue_put :: Ptr CQueue → Int → IO ()
foreign import capi "queue.h get" queue_get :: Ptr CQueue → IO Int
foreign import capi "queue.h size" queue_size :: Ptr CQueue → IO Int

