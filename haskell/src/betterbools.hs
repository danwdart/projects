{-# LANGUAGE GeneralisedNewtypeDeriving #-}

import Data.Coerce
import Unsafe.Coerce

newtype LightState = LightState Bool

data Lights = Off | On deriving (Enum, Eq, Ord, Show)

coerceEnum :: (Enum a, Enum b) => a -> b
coerceEnum = toEnum . fromEnum

main :: IO ()
main = do
    print (coerce $ LightState True :: Bool)
    print (unsafeCoerce $ Off :: Bool)
    print (fromEnum On :: Int)
    print (toEnum 0 :: Lights)
    print (toEnum (fromEnum Off) :: Bool)
    print (coerceEnum On :: Bool)