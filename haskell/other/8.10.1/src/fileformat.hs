{-# LANGUAGE OverloadedStrings #-}

import Data.Binary.Get
import Data.ByteString.Char8
import Data.Word

data Png = Png {
    magicNumber :: !Word32,
    version :: !Word32
} deriving (Show)



main :: IO ()
main = print (runGet (Png <$> getWord32le <*> getWord32le) "aaaaaaaa")