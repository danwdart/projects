data Foo = One | Two | Three deriving stock (Eq, Ord, Show, Read, Bounded, Enum)

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
