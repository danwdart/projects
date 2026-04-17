{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wwarn #-}

module Main (main) where

import Control.Monad.Random
-- import Data.List (List)
import Data.List qualified as L
import Data.Map
import Data.Map (Map) qualified as M

main :: IO ()
main = do
    let initialGameState = mkGame
    print initialGameState

    gameState2 <- performRound initialGameState
    print gameState2

{-
Simulate a shut the box session.
Given 12 flaps, one can roll 2 dice and shut that box.
If the box is already open, go with some strategy for flaps already open that total to that score.
If no combination sums to the total, the game is lost.
If only flaps 1-6 are still open, one dice can supplant two.
If all the flaps are closed whilst not breaking the rules, the game is won.
-}

data Flap = Closed | Open
    deriving stock (Eq, Show, Enum)

data Box = Box {
    unBox :: [Flap]
} deriving stock (Eq, Show)

data GameStatus = InProgress | Won | Lost
    deriving stock (Eq, Show)

data Game = Game {
    box :: Box,
    numDice :: Int,
    diceSides :: Int,
    gameStatus :: GameStatus
} deriving stock (Eq, Show)

mkBox :: Int -> Box
mkBox numFlaps = Box $ replicate numFlaps Open

mkGame :: Game
mkGame = Game {
    box = mkBox 12,
    numDice = 2,
    diceSides = 6,
    gameStatus = InProgress
}

setAt :: Int -> a -> [a] -> [a]
setAt n v xs = take (n - 1) xs <> [v] <> undefined

setMulti :: [Int] -> a -> [a] -> [a]
setMulti indices = undefined

findSubset :: Int -> [Flap] -> Maybe [Int]
findSubset = undefined

setWonIfWon :: Game -> Game
setWonIfWon game@Game { box = Box flaps } =
    if all (== Closed) flaps
    then game { gameStatus = Won }
    else game

adjustDice :: Game -> Game
adjustDice game@Game { box = Box flaps, diceSides = diceSides' } =
    if all (== Closed) (drop diceSides' flaps)
    then game { numDice = 1 }
    else game

performRound :: (MonadIO m, MonadRandom m) => Game -> m Game
performRound game@Game { box = Box flaps, numDice = numDice', diceSides = diceSides' } = do
    curScore <- d numDice' diceSides'
    pure $ setWonIfWon $ adjustDice $ 
        if flaps !! curScore == Open
        then
            game { box = Box $ setAt curScore Closed flaps, numDice = numDice' }
        else
            case findSubset curScore flaps of
                Nothing -> game { gameStatus = Lost }
                Just subset -> game { box = Box $ setMulti subset Closed flaps }
            -- Find a subset

-- urgh MonadIO
-- | Roll dice.
d :: (MonadRandom m, MonadIO m) => Int -> Int -> m Int
d times possibilities = sum <$> replicateM times (randomRIO (1, possibilities))