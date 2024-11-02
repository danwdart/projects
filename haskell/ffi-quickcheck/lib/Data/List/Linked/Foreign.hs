{-# LANGUAGE CApiFFI                  #-}
{-# LANGUAGE Unsafe                   #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-safe #-}

module Data.List.Linked.Foreign where

import Foreign
import Foreign.C

-- TODO get this from the header file? Do we just run c2hs/hsc2hs on a file like this with includes in it?
-- TODO what if we used unboxed types?
data CLL = CLL {
    value :: Ptr CChar,
    next :: Ptr CLL
}

foreign import capi "libll.h newlist" cnewlist :: IO (Ptr CLL)
foreign import capi "libll.h printlist" cprintlist :: Ptr CLL -> CInt -> IO ()
foreign import capi "libll.h from_array" cfromarray :: Ptr (Ptr CChar) -> CInt -> Ptr CLL
foreign import capi "libll.h insert" cinsert :: Ptr CChar -> Ptr CLL -> IO ()

-- Reimplement in Foreign - These should be the same
newlist :: IO (Ptr CLL)
newlist = undefined
{-
return (LL*) malloc(sizeof(LL));
-}

printlist :: Ptr CLL -> CInt -> IO ()
printlist = undefined
{-
printf("%d: %s\n", from, list->value);

    if (NULL != list->next) {
        printlist(list->next, from + 1);
    }
-}

fromarray :: Ptr (Ptr CChar) -> CInt -> Ptr CLL
fromarray = undefined
{-
LL* list = newlist();
    LL* orig_list = list;
    for (int i = 0; i < size; i++) {
        list->value = array[i];
        list->next = newlist();
        list = list->next;
    }    
    return orig_list;
-}

insert :: Ptr CChar -> Ptr CLL -> IO ()
insert = undefined
{-
char **tracer;
-}