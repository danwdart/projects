{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.Binary
import Data.ByteString.Char8
import GHC.Generics

data Png = Png {
    magicNumber :: !Word32,
    version     :: !Word32
} deriving (Generic, Binary, Show)

main :: IO ()
main = do
    print (decode "aaaaaaaa" :: Png)
    print . encode $ Png 10 10
    print (decode "A\NUL\NUL\NUL\NUL\NUL\NUL\NUL\fHello World!v" :: Variable)
    print . encode $ Variable { Main.length = 12, var = "AAAAAAAAAAAA", tree = 65 }

data Variable = Variable {
    length :: !Word8,
    var :: !ByteString,
    tree :: !Word8
} deriving (Generic, Binary, Show)