module Symbol where

class Symbol a where
    symbol :: a → String

printSymbol ∷ Symbol a ⇒ a → IO ()
printSymbol = putStrLn . symbol
