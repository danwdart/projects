module Main (main) where

-- Practice folding.

import Data.Foldable
import Data.Monoid

main ∷ IO ()
main = do
    print . getSum $ foldMap' Sum [1,2,3,4 :: Int]
