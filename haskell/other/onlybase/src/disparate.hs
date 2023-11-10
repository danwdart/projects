{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}

module Main (main) where

import Disparate

as ∷ [Disparate]
as = [
    ShowableDisparate $ Just (1 :: Int),
    ShowableDisparate (2 :: Int),
    ShowableDisparate "Hi",
    HiddenDisparate ($)]

bs ∷ [NamedDisparate]
bs = [
    NamedDisparate {name = "Jim", idn = -1, thing = ShowableDisparate "My Name Is Jim!"},
    NamedDisparate {name = "Bob", idn = 0, thing = HiddenDisparate $ \x a -> x a },
    NamedDisparate {name = "Comb", idn = 1, thing = HiddenDisparate (.)},
    NamedDisparate {name = "Comb2", idn = 2, thing = HiddenDisparate $ (.) (.) }]

cs ∷ [NamedDisparate]
cs = fmap (\n -> NamedDisparate {name = "Bob" <> show n, idn = n, thing = HiddenDisparate (.) }) [1..5]

ds ∷ [NamedDisparate]
ds = take 5 . iterate (\(NamedDisparate n i (HiddenDisparate b)) -> NamedDisparate n (i + 1) (HiddenDisparate b)) $ NamedDisparate "Bob" 1 (HiddenDisparate (.))

main ∷ IO ()
main = do
    print as
    print bs
    print cs
    print ds
