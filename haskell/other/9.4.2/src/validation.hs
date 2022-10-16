module Main where

import Data.Either.Validation

main :: IO ()
main = do
    let ke = Left "Why?: "
    let je = Left "This"
    let me = Right "Yeaah."
    print @(Either String String) (ke <> je)
    print @(Either String String) me
    let k = Failure "Why?: "
    let j = Failure "This"
    let m = Success "Yeaah."
    print @(Validation String String) (k <> j)
    print @(Validation String String) m
