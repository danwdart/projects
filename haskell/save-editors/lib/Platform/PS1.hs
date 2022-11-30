module Platform.PS1 where

import           Control.Monad   (unless)
import           Data.Binary.Get

magicNumber :: Get ()
magicNumber = do
    magicNumber' <- getWord16le -- PS1 is MIPS LE
    unless (magicNumber' == 0x434D) $ fail "Not a PS2 file."
