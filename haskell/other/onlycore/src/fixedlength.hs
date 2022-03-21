{-# OPTIONS_GHC -Wno-unused-imports #-}

-- Fixed length array splitting.
-- @TODO vector?

import Data.Array

l :: Array Int (Array Int String)
l = listArray (0, 1) [
    listArray (0, 3) ["a", "b", "c", "d"],
    listArray (0, 3) ["e", "f", "g", "h"]
    ]

k :: Array Int Int
k = listArray (0, 3) [0, 0, 0, 0]

main :: IO ()
main = do
    print $ elems k
    print . elems $ elems <$> l