{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

main ∷ IO ()
main = pure ()

type NumHooks = Int

newtype Hook = Hook {
    getHookNo :: Int
} deriving stock (Eq, Show)

makeHooks ∷ NumHooks → [Hook]
makeHooks = undefined

data Direction = Clockwise | Anticlockwise deriving stock (Enum, Eq, Show)

type Hang = (Hook, Direction)

type PotentialSolution = [Hang]

data IterationStats a = IterationStats {
    steps    :: Integer,
    sequence :: [a],
    result   :: a
} deriving stock (Show)

iterateUntilUnchanged ∷ (a → a) → a → a
iterateUntilUnchanged = undefined

iterateUntilUnchangedWithStats ∷ (a → a) → a → IterationStats a
iterateUntilUnchangedWithStats = undefined

initialSeq ∷ PotentialSolution
initialSeq = undefined

flattenSeq ∷ PotentialSolution → PotentialSolution
flattenSeq = undefined

isFallingSolution ∷ PotentialSolution → Bool
isFallingSolution = null . flattenSeq
