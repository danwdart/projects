-- | Module for displaying a card in ANSI.
module ANSI where

-- | Class for displaying a card in ANSI.
class ANSI a where
    renderANSI :: a -> String
    -- @TODO maybe renderANSIs :: [a] -> String
    displayANSI :: a -> IO ()
    displayANSI = putStrLn . renderANSI