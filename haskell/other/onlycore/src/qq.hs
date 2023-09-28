{-# LANGUAGE QuasiQuotes #-}

module Main where

import TH

someone ∷ String
someone = "You"

-- These don't get replaced by default, it's just a plain string...?
st ∷ String
st = [s|
        Hello World #{someone}
    |]

main ∷ IO ()
main = print st
