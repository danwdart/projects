{-# OPTIONS_GHC -Wwarn #-}

module Main (main) where

import Card
import Control.Lens
import Control.Monad.Random
import Control.Monad.State
-- import Data.Ratio
-- import Deck
import Value.Bounded.Standard qualified
import Value.Unbounded qualified

-- Emulate a Blackjack game.

main :: IO ()
main = pure ()

-- Strategies

newtype Pot = Pot Int
    deriving stock (Eq, Show)

data BettingStrategy
    = AlwaysMinimum
    | HigherAfterWinLowerAfterLoss Int Int
    | HigherAfterLossLowerAfterWin Int Int
    | PercentageOfPot Int
    deriving stock (Eq, Show)

data Score = Soft Int | Hard Int -- easier than S | H
    deriving stock (Eq, Show)

data HandState = In Score | Bust
    deriving stock (Eq, Show)

addScore :: Score -> Int -> HandState
addScore (Soft n) m
    | n + m > 21 = In $ Hard (n + m - 10)
    | otherwise = In $ Soft (n + m)
addScore (Hard n) m
    | n + m > 21 = Bust
    | otherwise = In $ Hard (n + m)

-- Rules things
data DealerHitsOn = DealerHitsOn Score
    deriving stock (Eq, Show)

data Rules = Rules {
    dealerHitsOn :: DealerHitsOn,
    blackjackPays :: Rational,
    doubleAfterSplitAllowed :: Bool,
    surrenderAllowed :: Bool
}
    deriving stock (Eq, Show)
-- End rules things

-- This is like Deck but allows for more
data Shoe card = Shoe {
    getShoe :: [card]
} deriving stock (Eq, Foldable, Functor, Show)

data Game card = Game {
    shoe :: Shoe card,
    pot :: Pot,
    rules :: Rules,
    bettingStrategy :: BettingStrategy,
    hands :: [HandState]
}
    deriving stock (Eq, Show)

-- todo: we could have some kind of validation / restricted number class here
class BlackjackScore a where
    toScore :: a -> Int
    
instance BlackjackScore Value.Bounded.Standard.Value where
    toScore n
        | fromEnum n == 1 = 11
        | fromEnum n > 1 && fromEnum n <= 10 = fromEnum n
        | fromEnum n > 10 = 10
        | otherwise = error $ "what is " <> show n

instance BlackjackScore Value.Unbounded.Value where
    toScore (Value.Unbounded.Value n)
        | n == 1 = 11
        | n > 1 && n <= 10 = n
        | n > 10 = 10
        | otherwise = error $ "what is " <> show n

instance BlackjackScore value => BlackjackScore (Card value suit) where
    toScore (Card value _) = toScore value 

-- meta of what to do to the score next
data Decision = Stand | Double | Hit | Split | Surrender
    deriving stock (Eq, Show)

data HandResult = Win | Lose | Push | Blackjack | DealerBlackjack
    deriving stock (Eq, Show)

-- decideMove :: Score -> Decision

-- decideMoves :: [Score] -> [Decision]
-- decideMoves = 

-- playMove ::

-- Applying a decision 
-- applyMove :: Score -> Decision -> m [Score]

-- applyMoves :: [Score] -> [Decision] -> m [Score]

-- Run a round:
-- 1. pull out a few cards, then hide one
-- 2. find out total combined score so far
-- 3. decide on strategy
-- 4. apply strategy
    -- 4a. should you keep going? yes -> 3, no -> 5
-- 5. either you win or you lose, find out what the result is
-- 6. remove cards, update running score.

runRound :: (MonadRandom m, MonadState (Game card) m) => m ()
runRound = undefined

-- is there any point
-- runRoundStateless :: (MonadRandom m) => s -> m s