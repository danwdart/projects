module Main (main) where

import Factor

perfect ∷ [Integer]
perfect = filter (\x -> sum (factors x) == 2 * x) [1..]

triperfect ∷ [Integer]
triperfect = filter (\x -> sum (factors x) == 3 * x) [1..]

fourperfect ∷ [Integer]
fourperfect = filter (\x -> sum (factors x) == 4 * x) [1..]

fiveperfect ∷ [Integer]
fiveperfect = filter (\x -> sum (factors x) == 4 * x) [1..]

main ∷ IO ()
main = do
    print . take 2 $ perfect
    print . take 2 $ triperfect
    print . take 2 $ fourperfect
    print . take 2 $ fiveperfect
