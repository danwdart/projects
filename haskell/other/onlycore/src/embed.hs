{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE Trustworthy     #-}
{-# OPTIONS_GHC -Wno-unsafe #-}

module Main (main) where

import Language.Haskell.TH

main ∷ IO ()
main = putStrLn bob

bob ∷ String
bob = $(stringE =<< runIO (readFile "onlycore.cabal"))
