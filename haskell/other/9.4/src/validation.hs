module Main where

import Data.Either.Validation

ke :: Either String String
ke = Left "Why?: "

je :: Either String String
je = Left "This"

me :: Either String String
me = Right "Yeaah."

k :: Validation String String
k = Failure "Why?: "

j :: Validation String String
j = Failure "This"

m :: Validation String String
m = Success "Yeaah."

main :: IO ()
main = do
    print $ ke <> je
    print me
    print $ k <> j
    print m