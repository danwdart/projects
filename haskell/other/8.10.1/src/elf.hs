{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString as BS
-- import Data.Function
import           Data.Elf
import           Data.Functor

main :: IO ()
main = (BS.readFile "/usr/bin/apt" <&> parseElf) >>= print . elfMachine
