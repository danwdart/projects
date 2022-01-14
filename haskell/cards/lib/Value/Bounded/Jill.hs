module Value.Bounded.Jill where

data Value = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Jill | Queen | King
    deriving (Bounded, Enum, Eq, Ord, Show)