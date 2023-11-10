{-# LANGUAGE Unsafe #-}
{-# OPTIONS_GHC -Wno-unsafe #-} -- ???

module Main (main) where

data Dokis = Yuri deriving stock (Show)

myLove ∷ Maybe Dokis
myLove = pure Yuri

main ∷ IO ()
main = print myLove
