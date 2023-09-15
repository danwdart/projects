{-# OPTIONS_GHC -Wno-unused-imports #-}

module Main where

import           ANSI
import           Data.List.Extra
import           Uno.Action.Bounded
import           Uno.Card
import           Uno.Colour.Bounded
import           Uno.Value.Bounded
import           Uno.Wild.Bounded
import           System.Random.Shuffle

main ∷ IO ()
main = do
    putStrLn $ show (length allCards) <> " cards in total."
    shuffled <- shuffleM allCards
    putStrLn $ "Shuffled deck: " <> renderANSI shuffled
    let (p1Hand, rest) = splitAt 7 shuffled
    putStrLn $ "Player 1: " <> renderANSI p1Hand
    let (p2Hand, rest') = splitAt 7 rest
    putStrLn $ "Player 2: " <> renderANSI p2Hand
    let (tryMatch, _discard) = splitAt 1 rest'
    putStrLn $ "Seeing if this is ok to start: " <> renderANSI tryMatch