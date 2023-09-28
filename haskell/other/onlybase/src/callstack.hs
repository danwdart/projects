{-# OPTIONS_GHC -Wno-redundant-constraints #-}

module Main where

import GHC.Stack

die ∷ a
die = error "Died"

passDie ∷ HasCallStack ⇒ IO a
passDie = die

num ∷ HasCallStack ⇒ IO Int
num = passDie

main ∷ IO ()
main = print =<< num
