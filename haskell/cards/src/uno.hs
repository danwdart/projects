{-# OPTIONS_GHC -Wno-unused-imports #-}

module Main where

import           Data.List.Extra
import           Uno.Action.Bounded
import           Uno.Card
import           Uno.Colour.Bounded
import           Uno.Value.Bounded
import           Uno.Wild.Bounded

examples ∷ [CardBounded]
examples = [NumberCard One Red, ActionCard Skip Yellow, WildCard Wild]

-- all the combinations, I think:

-- NumberCard <$> enumerate <*> enumerate :: [CardBounded] -- one zero, two of the rest
-- ActionCard <$> enumerate <*> enumerate :: [CardBounded] -- two of each
-- WildCard <$> enumerate :: [CardBounded] -- 4 wild, 4 wild draw 4, 3 customisable, 1 wild

main ∷ IO ()
main = print examples
