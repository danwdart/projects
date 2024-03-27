{-# LANGUAGE Safe #-}

{- | Ability to have args in any order? -}
module Main (main) where

import Data.List.Findable qualified as F

main ∷ IO ()
main = do
    putStrLn "I forgot which way round these go, so..."
    print (F.find [1,2,3 :: Int] (== (1 :: Int)) :: Maybe Int)
    print (F.find (== (1 :: Int)) [1,2,3 :: Int] :: Maybe Int)
