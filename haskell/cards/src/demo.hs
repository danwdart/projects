module Main (main) where

import Data.Enum
import Data.Foldable
import Ordering
import Suit.Bounded.Standard
import Symbol
import Value.Bounded.Standard

main ∷ IO ()
main = do
    traverse_ (putStr . symbol . getBySuitThenValue @Value @Suit) enumerate
    putStrLn ""
