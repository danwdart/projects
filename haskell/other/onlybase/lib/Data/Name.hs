{-# LANGUAGE Safe #-}

module Data.Name (
    Name (..)
) where

data Name = MonoName String |
    DuoName String String |
    TrioName String String String
    deriving stock (Show)
