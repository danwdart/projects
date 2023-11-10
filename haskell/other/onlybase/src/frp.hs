{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

type Event t a = [(t, a)]
type Behaviour t a = t → a

main ∷ IO ()
main = pure ()
