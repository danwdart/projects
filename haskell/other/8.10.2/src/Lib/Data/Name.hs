<<<<<<< Updated upstream:haskell/other/8.10.2/src/Lib/Data/Name.hs
{-# LANGUAGE UnicodeSyntax #-}
module Lib.Data.Name (
    Name (..)
) where

data Name = MonoName String |
    DuoName String String |
    TrioName String String String
    deriving (Show)
=======
module Lib.Data.Name (
    Name (..)
) where

data Name = MonoName String |
    DuoName String String |
    TrioName String String String
    deriving (Show)
>>>>>>> Stashed changes:haskell/Lib/Data/Name.hs
