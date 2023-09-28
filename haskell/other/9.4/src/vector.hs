{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE Trustworthy     #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-imports #-}

import Data.Vector

a ∷ Vector Int
a = [0, 0, 0, 0]

main ∷ IO ()
main = print a
