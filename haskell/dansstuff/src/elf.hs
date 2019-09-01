{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString as BS
import Data.Function
import Data.Functor
import Data.Elf

main :: IO ()
main = BS.readFile "/usr/bin/apt" <&> parseElf <&> elfMachine >>= print