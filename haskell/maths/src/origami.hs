{-# OPTIONS_GHC -Wno-unused-top-binds -Wno-unused-imports -Wno-type-defaults #-}

import Data.Complex
import Data.Complex.Cyclotomic
import Data.Maybe
import Data.Ratio

default(Cyclotomic, Integer)

midpoint :: Cyclotomic -> Cyclotomic -> Cyclotomic
midpoint a b = (a + b) / 2

upperRight, upperLeft, lowerLeft, lowerRight :: Cyclotomic
upperRight = 1 + i
upperLeft = i - 1
lowerLeft = -1 - i
lowerRight = 1 - i

mag :: Cyclotomic -> Maybe Cyclotomic
mag x = sqrtRat <$> toRat ((real x ^ 2) + (imag x ^ 2))

arg :: Cyclotomic -> Cyclotomic
arg = undefined

sqrtCyc :: Cyclotomic -> Maybe Cyclotomic
sqrtCyc x = do
    magx <- mag x
    ra <- toRat $ (magx + real x) / 2
    rb <- toRat $ (magx - real x) / 2
    pure $ sqrtRat ra + i * sqrtRat rb

-- Define a square
initialPoints :: [Cyclotomic]
initialPoints = [
    upperRight,
    upperLeft,
    lowerLeft,
    lowerRight
    ]

centrePoint :: Cyclotomic
centrePoint = 0

main :: IO ()
main = pure ()