module Main (main) where

import Data.Typeable
-- import Data.Dynamic

data A = C deriving stock (Show)

result ∷ String
result = show C <> (" is a " <> (show (typeOf C) <> "!"))

main ∷ IO ()
main = print result
