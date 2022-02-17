{-# LANGUAGE DerivingVia   #-}
{-# LANGUAGE UnicodeSyntax #-}

module Value.Bounded.Standard where

data Value = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King
    deriving (Bounded, Enum, Eq, Ord, Show)
