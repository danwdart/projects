{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE Trustworthy #-}
{-# OPTIONS_GHC -Wno-unsafe -Wno-unused-matches  #-}

module Main where

import           Control.Monad.Freer
import           Control.Monad.Freer.State
import           Control.Monad.Freer.Writer

type MyM = Eff '[State Int, Writer [String]]

eff ∷ MyM String
eff = do
    tell ["hi"]
    put (3 :: Int)
    o <- get :: MyM Int
    pure . show $ o

main ∷ IO ()
main = print . run . runWriter . evalState 2 $ eff
