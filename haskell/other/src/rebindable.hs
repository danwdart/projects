{-# LANGUAGE RebindableSyntax #-}

import Prelude hiding ((>>=), (>>), return)

ints :: Int
ints = do
    1
    2
    3
    4
    5
    where (>>) = (+)
          return = id

main :: IO ()
main = print ints