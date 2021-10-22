{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax     #-}

import qualified Data.ByteString as BS
-- import Data.Function
import           Data.Elf

main ∷ IO ()
main = BS.readFile "/bin/sh" >>= (print . elfMachine) . parseElf
