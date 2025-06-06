module Main (main) where

import Data.Foldable
import Data.These

thisOne ∷ These Int Int
thisOne = This 1

thatTwo ∷ These Int Int
thatTwo = That 2

these12 ∷ These Int Int
these12 = These 1 2

main ∷ IO ()
main = traverse_ putStrLn [
    show these12,
    show thisOne,
    show thatTwo,
    show $ fromThese 1 2 thisOne,
    show $ fromThese 1 2 thatTwo,
    show $ fromThese 1 2 these12,
    show $ these id id (+) these12
    ]
