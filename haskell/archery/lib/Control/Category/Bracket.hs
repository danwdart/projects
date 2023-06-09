{-# LANGUAGE Safe #-}

module Control.Category.Bracket where

-- | Bracket an expression to make it safe to inject into a string.
-- | This is for the purposes of ... what's it called
class Bracket cat where
    bracket :: cat a b → cat a b
