{-# OPTIONS_GHC -Wno-unused-imports #-}

module BreakEverything where

import           Prelude (IO, Int, Maybe (..), Show, String, print,
                          putStrLn, show, ($), (<>))

(+), (*) ∷ (Show a) ⇒ a → a → String
a + b = show a <> show b
a * b = show [a] <> show [b]

(/), div ∷ (Show a) ⇒ a → a → Maybe String

a / b = Just $ show a <> ("/" <> show b)
div a b = Just $ show a <> (" div " <> show b)