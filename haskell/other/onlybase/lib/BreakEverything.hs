{-# LANGUAGE Safe #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

-- | Hahahahaha.
module BreakEverything where

import Prelude (IO, Int, Maybe (..), Show, String, print, putStrLn, show, ($),
                (<>))

-- >>> 1 + 2
-- "12"

-- >>> 1 * 2
-- "[1][2]"

(+), (*) ∷ (Show a) ⇒ a → a → String
a + b = show a <> show b
a * b = show [a] <> show [b]

-- >>> 1 / 4
-- Just "1/4"

-- >>> div 3 19
-- Just "3 div 19"

(/), div ∷ (Show a) ⇒ a → a → Maybe String

a / b = Just $ show a <> ("/" <> show b)
div a b = Just $ show a <> (" div " <> show b)
