<<<<<<< Updated upstream:haskell/other/8.10.2/src/enum.hs
{-# LANGUAGE UnicodeSyntax #-}
data Foo = One | Two | Three deriving (Eq, Ord, Show, Read, Bounded, Enum)

thing ∷ Foo
thing = One

{-
athing = read "One" :: Foo
another = read "\"Four\"" :: String

allofthem = [One .. Three]

allthings :: (Bounded a, Enum a) => [a]
allthings = [minBound .. maxBound]

allfoos = allthings :: [Foo]
-}

main ∷ IO ()
main = print thing
=======
data Foo = One | Two | Three deriving (Eq, Ord, Show, Read, Bounded, Enum)

thing :: Foo
thing = One

athing = read "One" :: Foo
another = read "\"Four\"" :: String

allofthem = [One .. Three]

allthings :: (Bounded a, Enum a) => [a] 
allthings = [minBound .. maxBound]

allfoos = allthings :: [Foo]



main = print thing
>>>>>>> Stashed changes:haskell/enum.hs
