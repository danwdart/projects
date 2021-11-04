{-# LANGUAGE PostfixOperators #-}

import Numeric.Natural

(!) :: Natural -> Natural
(!) 0 = 0
(!) 1 = 1
(!) x = x * ((x - 1)!)

main :: IO ()
main = print (12!)