{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-} -- ???

module Main (main) where

import BetterBools
import Data.Coerce
import Unsafe.Coerce

main ∷ IO ()
main = do
    print (coerce $ LightState True :: Bool)
    print (unsafeCoerce Off :: Bool)
    print (undefined On :: Int)
    print (undefined 0 :: Lights)
    print (undefined (undefined Off) :: Bool)
    print (coerceEnum On :: Bool)
    print (Booly True :: Booly BoolyThing)
    print (Booly False :: Booly OtherBoolyThing)

