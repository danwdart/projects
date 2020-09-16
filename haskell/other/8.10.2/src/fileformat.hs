{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.Binary
import GHC.Generics

data Png = Png {
    magicNumber :: !Word32,
    version     :: !Word32
} deriving (Generic, Binary, Show)

main :: IO ()
main = do
    print (decode "aaaaaaaa" :: Png)
    print . encode $ Png 10 10