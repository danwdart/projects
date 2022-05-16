{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-} -- ???

import           BetterBools
import           Data.Coerce
import           Unsafe.Coerce

main ∷ IO ()
main = do
    print (coerce $ LightState True :: Bool)
    print (unsafeCoerce Off :: Bool)
    print (fromEnum On :: Int)
    print (toEnum 0 :: Lights)
    print (toEnum (fromEnum Off) :: Bool)
    print (coerceEnum On :: Bool)
