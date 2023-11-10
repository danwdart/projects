module Main (main) where

-- discrete/continuous?
-- validation?
{-

newtype Cardinal = Cardinal Int deriving stock (Show)
newtype Ordinal = Ordinal Int deriving stock (Show)

intToCard :: Int -> Cardinal
intToCard = Cardinal

--intToOrd :: Int -> Maybe Ordinal
--intToOrd n = if 1 > n then Nothing else Just (n - 1)

--cardToOrd :: Cardinal -> Maybe Ordinal
--cardToOrd (Cardinal n) = intToOrd n Ordinal (intToOrd n)

ordToCard :: Ordinal -> Cardinal
ordToCard (Ordinal n) = Cardinal (n + 1)

data OrdinalOrdering = Before | SamePos | After deriving stock (Show)

compareOrdinal :: Ordinal -> Ordinal -> OrdinalOrdering
compareOrdinal (Ordinal x) (Ordinal y) = case compare x y of
    LT -> Before
    EQ -> SamePos
    GT -> After
-}
main ∷ IO ()
main = pure ()
