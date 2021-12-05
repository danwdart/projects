{-# LANGUAGE UnicodeSyntax #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

{-|
    One of my own submitted OEIS sequences.

    Hash Parker numbers:
    Integers whose real 32nd root's first six nonzero digits
    (after the decimal point)
    rearranged in ascending order are equal to 234477
-}

import           Data.List

hash ∷ Double → Int
hash = read . sort . take 6 . filter (/='0') . drop 1 . dropWhile (/='.')  . show . (** 0.03125)

results ∷ [Integer]
results = fmap (floor . fst) . filter ((==234477) . snd) $ fmap (\x -> (x, hash x)) ([2..1000000] :: [Double])

hashes ∷ [Int]
hashes = fmap hash ([2..1000] :: [Double])

main ∷ IO ()
main = print results
