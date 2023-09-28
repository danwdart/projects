-- | Module for displaying a card in ANSI.
module ANSI where

import Data.List.NonEmpty qualified as LNE

-- | Class for displaying a card in ANSI.
class ANSI a where
    renderANSI :: a → String
    -- @TODO maybe renderANSIs :: [a] -> String
    displayANSI :: a → IO ()
    displayANSI = putStrLn . renderANSI


instance (ANSI a) ⇒ ANSI [a] where
    renderANSI []     = ""
    renderANSI (x:xs) = renderANSI x <> renderANSI xs

instance (ANSI a) ⇒ ANSI (LNE.NonEmpty a) where
    renderANSI (x LNE.:| xs) = renderANSI x <> renderANSI xs
